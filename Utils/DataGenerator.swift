import Foundation

struct DataGenerator {
    static func generateClusteredData(clusterCount: Int, pointsPerCluster: Int) -> [DataPoint] {
        var points: [DataPoint] = []
        
        for cluster in 0..<clusterCount {
            let centerX = Double.random(in: -0.8...0.8)
            let centerY = Double.random(in: -0.8...0.8)
            
            for _ in 0..<pointsPerCluster {
                let x = centerX + Double.random(in: -0.2...0.2)
                let y = centerY + Double.random(in: -0.2...0.2)
                points.append(DataPoint(x: x, y: y, category: cluster))
            }
        }
        
        return points
    }
}