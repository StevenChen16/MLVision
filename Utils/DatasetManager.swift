import Foundation

enum DatasetType {
    case classification
    case regression
}

struct Dataset {
    let name: String
    let description: String
    let type: DatasetType
    let data: [DataPoint]
}

class DatasetManager {
    static let shared = DatasetManager()
    
    private init() {}
    
    // 预设数据集
    let presetDatasets: [Dataset] = [
        // 分类数据集
        Dataset(
            name: "Iris-like Flower Data",
            description: "A simplified version of the famous Iris dataset, showing two features of different flower types.",
            type: .classification,
            data: [
                // Class 1
                DataPoint(x: 0.2, y: 0.3, category: 0),
                DataPoint(x: 0.3, y: 0.4, category: 0),
                DataPoint(x: 0.2, y: 0.5, category: 0),
                DataPoint(x: 0.1, y: 0.4, category: 0),
                DataPoint(x: 0.25, y: 0.45, category: 0),
                
                // Class 2
                DataPoint(x: 0.7, y: 0.8, category: 1),
                DataPoint(x: 0.8, y: 0.7, category: 1),
                DataPoint(x: 0.75, y: 0.75, category: 1),
                DataPoint(x: 0.85, y: 0.8, category: 1),
                DataPoint(x: 0.7, y: 0.7, category: 1)
            ]
        ),
        
        Dataset(
            name: "Circular Pattern",
            description: "A dataset showing two classes in a circular pattern, demonstrating non-linear separation.",
            type: .classification,
            data: [
                // Inner circle
                DataPoint(x: 0.5, y: 0.5, category: 0),
                DataPoint(x: 0.4, y: 0.5, category: 0),
                DataPoint(x: 0.5, y: 0.4, category: 0),
                DataPoint(x: 0.6, y: 0.5, category: 0),
                DataPoint(x: 0.5, y: 0.6, category: 0),
                
                // Outer circle
                DataPoint(x: 0.3, y: 0.3, category: 1),
                DataPoint(x: 0.3, y: 0.7, category: 1),
                DataPoint(x: 0.7, y: 0.3, category: 1),
                DataPoint(x: 0.7, y: 0.7, category: 1),
                DataPoint(x: 0.2, y: 0.5, category: 1)
            ]
        ),
        
        // 回归数据集
        Dataset(
            name: "Linear Trend",
            description: "A simple dataset showing a clear linear relationship with some noise.",
            type: .regression,
            data: [
                DataPoint(x: 0.1, y: 0.2),
                DataPoint(x: 0.2, y: 0.3),
                DataPoint(x: 0.3, y: 0.35),
                DataPoint(x: 0.4, y: 0.5),
                DataPoint(x: 0.5, y: 0.55),
                DataPoint(x: 0.6, y: 0.65),
                DataPoint(x: 0.7, y: 0.8),
                DataPoint(x: 0.8, y: 0.85),
                DataPoint(x: 0.9, y: 0.95)
            ]
        ),
        
        Dataset(
            name: "Quadratic Trend",
            description: "A dataset showing a quadratic relationship, demonstrating non-linear patterns.",
            type: .regression,
            data: [
                DataPoint(x: 0.1, y: 0.01),
                DataPoint(x: 0.2, y: 0.04),
                DataPoint(x: 0.3, y: 0.09),
                DataPoint(x: 0.4, y: 0.16),
                DataPoint(x: 0.5, y: 0.25),
                DataPoint(x: 0.6, y: 0.36),
                DataPoint(x: 0.7, y: 0.49),
                DataPoint(x: 0.8, y: 0.64),
                DataPoint(x: 0.9, y: 0.81)
            ]
        )
    ]
    
    // 获取特定类型的数据集
    func getDatasets(for type: DatasetType) -> [Dataset] {
        return presetDatasets.filter { $0.type == type }
    }
    
    // 保存自定义数据集
    func saveCustomDataset(_ dataset: Dataset) {
        // TODO: Implement persistence
    }
    
    // 加载自定义数据集
    func loadCustomDatasets() -> [Dataset] {
        // TODO: Implement loading from persistence
        return []
    }
}
