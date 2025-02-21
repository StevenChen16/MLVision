import Foundation

@MainActor
class KNNModel: ObservableObject {
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
    
    // 设置训练数据
    func setTrainingData(_ data: [DataPoint]) {
        self.trainingData = data
    }
    
    // 设置K值
    func setK(_ newK: Int) {
        self.k = max(1, min(newK, trainingData.count))
    }
    
    // 对新点进行分类
    func classify(_ point: DataPoint) -> Int? {
        guard !trainingData.isEmpty else { return nil }
        
        // 计算到所有点的距离
        let distances = trainingData.map { ($0, point.distance(to: $0)) }
        
        // 找到K个最近邻
        let kNearest = distances.sorted { $0.1 < $1.1 }.prefix(k)
        nearestNeighbors = kNearest.map { $0.0 }
        
        // 统计最近邻中各类别的数量
        let categoryCounts = Dictionary(grouping: kNearest, by: { $0.0.category })
            .mapValues { $0.count }
        
        // 返回数量最多的类别
        return categoryCounts.max(by: { $0.value < $1.value })?.key
    }
    
    // 清除当前选择和最近邻
    func clearSelection() {
        selectedPoint = nil
        nearestNeighbors = []
    }
    
    func canPlace(_ module: ModuleType, at position: ModulePosition) -> Bool {
        // 检查是否可以在该位置放置模块
        guard placedModules[position] == nil else { return false }
        
        // 检查依赖关系
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
            
            // 更新说明文字
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
            
            // 使用 Task 来处理异步操作
            Task { @MainActor in
                try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
                currentModuleAnimation = nil
            }
        }
    }
    
    func removeModule(at position: ModulePosition) {
        placedModules.removeValue(forKey: position)
        // 重置相关状态
        switch position {
        case .kValueSelector:
            // 同时移除依赖的模块
            placedModules.removeValue(forKey: .distanceCalculator)
            placedModules.removeValue(forKey: .classifier)
            moduleInstructions = """
                Start by placing the K-Value Selector
                
                This module is the foundation of the KNN algorithm.
                It determines how many neighbors we'll consider for classification.
"""
        case .distanceCalculator:
            placedModules.removeValue(forKey: .classifier)
            moduleInstructions = """
                Place the Distance Calculator to continue
                
                This module will help us find the nearest neighbors
                by calculating distances between points.
"""
        case .classifier:
            moduleInstructions = """
                Complete the algorithm by placing the Classifier
                
                This final module will use the K nearest neighbors
                to classify new points based on their categories.
"""
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
