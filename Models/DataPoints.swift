import Foundation

struct DataPoint: Identifiable, Equatable {
    let id = UUID()
    var x: Double
    var y: Double
    var category: Int  // 分类标签
    var isSelected: Bool = false
    
    // 用于计算两点之间的距离
    func distance(to other: DataPoint) -> Double {
        let dx = x - other.x
        let dy = y - other.y
        return sqrt(dx * dx + dy * dy)
    }
}

// 用于生成示例数据
extension DataPoint {
    static func generateRandomPoints(count: Int, in rect: CGRect) -> [DataPoint] {
        return (0..<count).map { _ in
            let x = Double.random(in: rect.minX...rect.maxX)
            let y = Double.random(in: rect.minY...rect.maxY)
            let category = Int.random(in: 0...1)  // 简单起见，先用二分类
            return DataPoint(x: x, y: y, category: category)
        }
    }
}