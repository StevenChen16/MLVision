import SwiftUI

// Define data point structure
struct RegressionDataPoint: Identifiable {
    let id = UUID()
    let x: Double
    let y: Double
}

@MainActor
class LinearRegressionModel: ObservableObject {
    @Published var trainingData: [RegressionDataPoint] = []
    @Published var learningRate: Double = 0.01
    @Published var epochs: Int = 100
    @Published var currentEpoch: Int = 0
    @Published var slope: Double = 0.0
    @Published var intercept: Double = 0.0
    @Published var error: Double = 0.0
    @Published var isTraining: Bool = false
    @Published var selectedPoint: RegressionDataPoint?
    
    // Teaching-related states
    @Published var showPredictionLine: Bool = false
    @Published var showErrorLines: Bool = false
    @Published var showGradientArrows: Bool = false
    @Published var currentStep: TrainingStep = .initial
    @Published var stepDescription: String = ""
    @Published var instructions: String = """
        Welcome to Linear Regression Learning!
        
        Instructions:
        1. Click on the graph to add data points
        2. Use 'Next Step' to learn the algorithm step by step
        3. Use 'Auto Train' to see the full training process
        4. Adjust learning rate and epochs as needed
        
        Start by adding some data points to the graph!
        """
    
    enum TrainingStep {
        case initial
        case prediction
        case errorCalculation
        case gradientCalculation
        case parameterUpdate
    }
    
    // Add training data
    func addPoint(_ x: Double, _ y: Double) {
        let point = RegressionDataPoint(x: x, y: y)
        trainingData.append(point)
        updateStepDescription()
    }
    
    // Clear all data
    func clearData() {
        trainingData.removeAll()
        resetParameters()
    }
    
    // Reset parameters
    func resetParameters() {
        slope = 0.0
        intercept = 0.0
        error = 0.0
        currentEpoch = 0
        currentStep = .initial
        updateStepDescription()
    }
    
    // Update step description
    private func updateStepDescription() {
        switch currentStep {
        case .initial:
            stepDescription = """
                Step 1: Data Collection
                • Click on the graph to add data points
                • Each point represents a (x, y) pair in our dataset
                • Try to add points that show a linear pattern
                """
        case .prediction:
            stepDescription = """
                Step 2: Making Predictions
                • Current line equation: y = \(String(format: "%.2f", slope))x + \(String(format: "%.2f", intercept))
                • Blue line shows our current prediction
                • This line tries to fit through all points
                """
        case .errorCalculation:
            stepDescription = """
                Step 3: Calculating Error
                • Red dashed lines show prediction errors
                • Error = Predicted value - Actual value
                • We want to minimize these errors
                • Total Error: \(String(format: "%.4f", error))
                """
        case .gradientCalculation:
            stepDescription = """
                Step 4: Computing Gradients
                • Green arrows show how parameters should change
                • Arrow direction indicates whether to increase or decrease
                • Learning rate (\(String(format: "%.3f", learningRate))) determines step size
                """
        case .parameterUpdate:
            stepDescription = """
                Step 5: Updating Parameters
                • New slope = \(String(format: "%.2f", slope))
                • New intercept = \(String(format: "%.2f", intercept))
                • Parameters updated to reduce error
                • Click 'Next Step' to continue optimization
                """
        }
    }
    
    // Single step training
    func trainStep() async {
        guard !trainingData.isEmpty else { 
            stepDescription = "Please add some data points first!"
            return 
        }
        
        switch currentStep {
        case .initial:
            currentStep = .prediction
            showPredictionLine = true
        case .prediction:
            currentStep = .errorCalculation
            showErrorLines = true
        case .errorCalculation:
            currentStep = .gradientCalculation
            showGradientArrows = true
        case .gradientCalculation:
            currentStep = .parameterUpdate
        case .parameterUpdate:
            // Execute one parameter update
            var slopeGradient = 0.0
            var interceptGradient = 0.0
            var totalError = 0.0
            
            for point in trainingData {
                let prediction = slope * point.x + intercept
                let error = prediction - point.y
                
                slopeGradient += error * point.x
                interceptGradient += error
                totalError += error * error
            }
            
            slopeGradient = slopeGradient * 2 / Double(trainingData.count)
            interceptGradient = interceptGradient * 2 / Double(trainingData.count)
            
            slope -= learningRate * slopeGradient
            intercept -= learningRate * interceptGradient
            error = totalError / Double(trainingData.count)
            
            showPredictionLine = false
            showErrorLines = false
            showGradientArrows = false
            currentStep = .initial
        }
        
        updateStepDescription()
    }
    
    // Auto train
    func train() async {
        guard !trainingData.isEmpty else { return }
        
        isTraining = true
        resetParameters()
        
        for epoch in 0..<epochs {
            if !isTraining { break }
            
            var totalError = 0.0
            var slopeGradient = 0.0
            var interceptGradient = 0.0
            
            for point in trainingData {
                let prediction = slope * point.x + intercept
                let error = prediction - point.y
                
                slopeGradient += error * point.x
                interceptGradient += error
                totalError += error * error
            }
            
            slopeGradient = slopeGradient * 2 / Double(trainingData.count)
            interceptGradient = interceptGradient * 2 / Double(trainingData.count)
            
            slope -= learningRate * slopeGradient
            intercept -= learningRate * interceptGradient
            
            error = totalError / Double(trainingData.count)
            currentEpoch = epoch + 1
            
            await Task.yield()
        }
        
        isTraining = false
    }
    
    // Predict
    func predict(_ x: Double) -> Double {
        return slope * x + intercept
    }
    
    // Stop training
    func stopTraining() {
        isTraining = false
    }
    
    // Coordinate conversion
    func convertToModelSpace(viewX: CGFloat, viewY: CGFloat, viewSize: CGSize) -> (x: Double, y: Double) {
        let x = Double((viewX / viewSize.width) * 2 - 1)
        let y = Double((viewY / viewSize.height) * 2 - 1)
        return (x: x, y: y)
    }
    
    func convertToViewSpace(modelX: Double, modelY: Double, viewSize: CGSize) -> CGPoint {
        let x = CGFloat((modelX + 1) / 2) * viewSize.width
        let y = CGFloat((modelY + 1) / 2) * viewSize.height
        return CGPoint(x: x, y: y)
    }
}
