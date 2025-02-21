import Foundation
import SwiftUI

@MainActor
class KNNModel: ObservableObject {
    // Published properties for UI updates
    @Published var trainingData: [DataPoint] = []
    @Published var k: Int = 3
    @Published var selectedPoint: DataPoint?
    @Published var nearestNeighbors: [DataPoint] = []
    @Published var placedModules: [ModulePosition: ModuleType] = [:]
    @Published var currentModuleAnimation: ModulePosition?
    @Published var moduleInstructions: String = """
        Welcome to KNN Algorithm Learning!
        
        Start by dragging the K-Value Selector module from the toolbox.
        This will allow you to control how many neighbors are considered for classification.
        
        Follow the instructions as you build the algorithm step by step.
"""
    @Published var isAnimating: Bool = false
    @Published var animationStep: Int = 0
    @Published var demoPoint: DataPoint?
    @Published var allDistances: [(DataPoint, Double)] = []  // Store distances to all points
    @Published var showAllDistances: Bool = false  // Control whether to show all distances

    // Set training data
    func setTrainingData(_ data: [DataPoint]) {
        self.trainingData = data
    }
    
    // Set K value
    func setK(_ newK: Int) {
        self.k = max(1, min(newK, trainingData.count))
    }
    
    // Classify a new point
    func classify(_ point: DataPoint) -> Int? {
        guard !trainingData.isEmpty else { return nil }
        
        // Calculate distances to all points
        let distances = trainingData.map { ($0, point.distance(to: $0)) }
        
        // Find K nearest neighbors
        let kNearest = distances.sorted { $0.1 < $1.1 }.prefix(k)
        nearestNeighbors = kNearest.map { $0.0 }
        
        // Count categories among nearest neighbors
        let categoryCounts = Dictionary(grouping: kNearest, by: { $0.0.category })
            .mapValues { $0.count }
        
        // Return the most common category
        return categoryCounts.max(by: { $0.value < $1.value })?.key
    }
    
    // Clear current selection and nearest neighbors
    func clearSelection() {
        selectedPoint = nil
        nearestNeighbors = []
    }
    
    func canPlace(_ module: ModuleType, at position: ModulePosition) -> Bool {
        // Check if a module can be placed at the given position
        guard placedModules[position] == nil else { return false }
        
        // Check module dependencies
        switch position {
        case .kValueSelector:
            return true
        case .distanceCalculator:
            return placedModules[.kValueSelector] != nil
        case .classifier:
            return placedModules[.distanceCalculator] != nil
        }
    }
    
    func placeModule(_ module: ModuleType, at position: ModulePosition) {
        if canPlace(module, at: position) {
            placedModules[position] = module
            currentModuleAnimation = position
            
            // Update instructions and trigger animation
            withAnimation(Animation.easeInOut(duration: 0.3)) {
                switch position {
                case .kValueSelector:
                    moduleInstructions = """
                        K-Value Selector placed! 
                        
                        This module lets you choose how many nearest neighbors to consider.
                        Use the slider below to adjust the K value
                        Higher K values make the model more stable but less flexible
                        Lower K values can capture more local patterns
                        
                        Next: Drag the Distance Calculator module to continue
"""
                case .distanceCalculator:
                    moduleInstructions = """
                        Distance Calculator placed! 
                        
                        This module measures how far apart points are from each other.
                        Click on any point to see its distances
                        Closer points have more influence on classification
                        The K closest points will be highlighted
                        
                        Next: Add the Classifier module to complete the algorithm
"""
                case .classifier:
                    moduleInstructions = """
                        Classifier placed! 
                        Algorithm complete!
                        
                        Now you can:
                        Click anywhere to classify new points
                        Adjust K value to see how it affects classification
                        Add more training points to improve accuracy
                        
                        Try experimenting with different patterns and K values!
"""
                }
            }
            
            // Use Task to handle asynchronous operations
            Task { @MainActor in
                try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
                withAnimation(Animation.easeInOut(duration: 0.3)) {
                    currentModuleAnimation = nil
                }
                
                // If this is the last module, show completion animation
                if position == .classifier {
                    try? await Task.sleep(nanoseconds: 500_000_000)
                    withAnimation(Animation.spring()) {
                        // Trigger completion animation
                        objectWillChange.send()
                    }
                }
            }
        }
    }
    
    func removeModule(at position: ModulePosition) {
        placedModules.removeValue(forKey: position)
        // Reset related state
        switch position {
        case .kValueSelector:
            // Remove dependent modules
            placedModules.removeValue(forKey: .distanceCalculator)
            placedModules.removeValue(forKey: .classifier)
            moduleInstructions = "Start by placing the K-Value Selector"
        case .distanceCalculator:
            placedModules.removeValue(forKey: .classifier)
            moduleInstructions = "Place the Distance Calculator to continue"
        case .classifier:
            moduleInstructions = "Complete the algorithm by placing the Classifier"
        }
    }
    
    func startDemoAnimation() {
        guard placedModules[.classifier] != nil else { return }
        
        isAnimating = true
        animationStep = 0
        clearSelection()
        
        // Create a demo point
        demoPoint = DataPoint(x: 0.2, y: 0.3, category: -1)
        
        Task { @MainActor in
            // Step 1: Show new point
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            withAnimation(.easeInOut(duration: 0.5)) {
                animationStep = 1
                moduleInstructions = """
                    Step 1: New Point Added
                    
                    A new point has been added to the visualization.
                    We will now demonstrate how KNN classifies this point.
                    Watch as we calculate distances to all training points.
"""
            }
            
            // Step 2: Calculate and show distances to all points
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            if let demo = demoPoint {
                // Calculate distances to all points
                allDistances = trainingData.map { ($0, demo.distance(to: $0)) }
                    .sorted { $0.1 < $1.1 }  // Sort by distance
                
                withAnimation(.easeInOut(duration: 0.5)) {
                    animationStep = 2
                    selectedPoint = demo
                    showAllDistances = true
                    moduleInstructions = """
                        Step 2: Calculate All Distances
                        
                        The algorithm calculates the distance from the new point
                        to every training point in the dataset.
                        
                        These distances help us find the closest neighbors.
"""
                }
                
                // Show distance lines one by one
                for i in 0..<allDistances.count {
                    try? await Task.sleep(nanoseconds: 200_000_000)  // 0.2 seconds interval
                    withAnimation(.easeInOut(duration: 0.2)) {
                        nearestNeighbors = Array(allDistances[0...i].map { $0.0 })
                    }
                }
            }
            
            // Step 3: Highlight K nearest neighbors
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            if let demo = demoPoint {
                withAnimation(.easeInOut(duration: 0.5)) {
                    animationStep = 3
                    showAllDistances = false  // Hide other distance lines
                    nearestNeighbors = Array(allDistances.prefix(k).map { $0.0 })
                    moduleInstructions = """
                        Step 3: Find K Nearest Neighbors
                        
                        From all the distances calculated, we select the \(k) closest points.
                        These \(k) nearest neighbors will vote on the classification.
                        
                        Notice how we only keep the closest \(k) points, ignoring the rest.
"""
                }
            }
            
            // Step 4: Classify the point
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            if let demo = demoPoint {
                let kNearest = Array(allDistances.prefix(k))
                let categoryCounts = Dictionary(grouping: kNearest, by: { $0.0.category })
                    .mapValues { $0.count }
                
                withAnimation(.easeInOut(duration: 0.5)) {
                    animationStep = 4
                    demoPoint?.category = classify(demo) ?? 0
                    moduleInstructions = """
                        Step 4: Classification by Majority Vote
                        
                        Each of the \(k) nearest neighbors votes with its category.
                        The new point is assigned the most common category among them.
                        
                        Category counts among nearest neighbors:
                        \(categoryCounts.map { "Category \($0.key): \($0.value) votes" }.joined(separator: "\n"))
                        
                        Try clicking anywhere to classify more points!
"""
                }
            }
            
            // End animation
            try? await Task.sleep(nanoseconds: 3_000_000_000)
            withAnimation(.easeInOut(duration: 0.5)) {
                isAnimating = false
                animationStep = 0
                showAllDistances = false
                clearSelection()
                allDistances = []
            }
        }
    }
    
    func getStepDescription() -> String {
        switch animationStep {
        case 0:
            return "Click 'Next' to start KNN demonstration"
        case 1:
            return "Generate a new point to classify (black circle)"
        case 2:
            return "Calculate distances to all training points"
        case 3:
            return "Find the nearest \(k) neighbor points"
        case 4:
            return "Vote based on these \(k) neighbors to determine the final classification"
        default:
            return ""
        }
    }
    
    func nextStep() {
        if animationStep < 4 {
            animationStep += 1
            updateAnimationState()
        }
    }
    
    func previousStep() {
        if animationStep > 0 {
            animationStep -= 1
            updateAnimationState()
        }
    }
    
    private func updateAnimationState() {
        switch animationStep {
        case 0:
            reset()
        case 1:
            generateDemoPoint()
        case 2:
            calculateDistances()
            showAllDistances = true
        case 3:
            findNearestNeighbors()
            showAllDistances = false
        case 4:
            classifyPoint()
        default:
            break
        }
    }
    
    func reset() {
        // Reset all state to initial values
        selectedPoint = nil
        demoPoint = nil
        nearestNeighbors.removeAll()
        allDistances.removeAll()
        showAllDistances = false
        animationStep = 0
        isAnimating = false
        placedModules.removeAll()
        moduleInstructions = "Place modules to start KNN demonstration"
    }
    
    func generateDemoPoint() {
        demoPoint = DataPoint(x: 0.2, y: 0.3, category: -1)
    }
    
    func calculateDistances() {
        if let demo = demoPoint {
            allDistances = trainingData.map { ($0, demo.distance(to: $0)) }
                .sorted { $0.1 < $1.1 }  // Sort by distance
        }
    }
    
    func findNearestNeighbors() {
        if let demo = demoPoint {
            nearestNeighbors = Array(allDistances.prefix(k).map { $0.0 })
        }
    }
    
    func classifyPoint() {
        if let demo = demoPoint {
            let kNearest = Array(allDistances.prefix(k))
            let categoryCounts = Dictionary(grouping: kNearest, by: { $0.0.category })
                .mapValues { $0.count }
            
            demoPoint?.category = classify(demo) ?? 0
        }
    }
}

enum ModulePosition: String, CaseIterable {
    case kValueSelector
    case distanceCalculator
    case classifier
    
    var nextPosition: ModulePosition? {
        switch self {
        case .kValueSelector: return .distanceCalculator
        case .distanceCalculator: return .classifier
        case .classifier: return nil
        }
    }
}
