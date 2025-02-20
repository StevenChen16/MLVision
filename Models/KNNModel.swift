import Foundation

class KNNModel: ObservableObject {
    @Published var trainingData: [DataPoint] = []
    @Published var k: Int = 3
    @Published var selectedPoint: DataPoint?
    @Published var nearestNeighbors: [DataPoint] = []
    
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

extension KNNModel {
    @Published var placedModules: [ModulePosition: ModuleType] = [:]
    
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
        }
    }
    
    func removeModule(at position: ModulePosition) {
        placedModules.removeValue(forKey: position)
    }
}

