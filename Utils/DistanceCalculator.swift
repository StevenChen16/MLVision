import Foundation

enum DistanceMetric {
    case euclidean
    case manhattan
    
    func calculate(from p1: DataPoint, to p2: DataPoint) -> Double {
        switch self {
        case .euclidean:
            let dx = p1.x - p2.x
            let dy = p1.y - p2.y
            return sqrt(dx * dx + dy * dy)
        case .manhattan:
            return abs(p1.x - p2.x) + abs(p1.y - p2.y)
        }
    }
}