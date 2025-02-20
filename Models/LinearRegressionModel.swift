import Foundation

class LinearRegressionModel: ObservableObject {
    @Published var trainingData: [(x: Double, y: Double)] = []
    @Published var slope: Double = 0.0
    @Published var intercept: Double = 0.0
    @Published var selectedPoint: (x: Double, y: Double)?
    @Published var isTraining: Bool = false
    @Published var learningRate: Double = 0.01
    @Published var epochs: Int = 100
    @Published var currentEpoch: Int = 0
    @Published var error: Double = 0.0
    
    // 添加训练数据
    func addPoint(_ x: Double, _ y: Double) {
        trainingData.append((x, y))
    }
    
    // 清除所有数据
    func clearData() {
        trainingData.removeAll()
        slope = 0.0
        intercept = 0.0
        error = 0.0
        currentEpoch = 0
    }
    
    // 预测函数
    func predict(_ x: Double) -> Double {
        return slope * x + intercept
    }
    
    // 计算均方误差
    func calculateMSE() -> Double {
        guard !trainingData.isEmpty else { return 0.0 }
        
        let errors = trainingData.map { point in
            let prediction = predict(point.x)
            return pow(prediction - point.y, 2)
        }
        
        return errors.reduce(0.0, +) / Double(trainingData.count)
    }
    
    // 梯度下降训练
    func train() {
        guard !trainingData.isEmpty else { return }
        
        isTraining = true
        currentEpoch = 0
        
        // 梯度下降主循环
        for epoch in 0..<epochs {
            var slopeGradient = 0.0
            var interceptGradient = 0.0
            
            // 计算梯度
            for point in trainingData {
                let prediction = predict(point.x)
                let error = prediction - point.y
                
                slopeGradient += error * point.x
                interceptGradient += error
            }
            
            // 更新参数
            slopeGradient /= Double(trainingData.count)
            interceptGradient /= Double(trainingData.count)
            
            slope -= learningRate * slopeGradient
            intercept -= learningRate * interceptGradient
            
            // 更新状态
            currentEpoch = epoch + 1
            error = calculateMSE()
            
            // 在主线程更新UI
            DispatchQueue.main.async {
                self.objectWillChange.send()
            }
        }
        
        isTraining = false
    }
    
    // 获取回归线的点
    func getRegressionLinePoints() -> [(x: Double, y: Double)] {
        guard !trainingData.isEmpty else { return [] }
        
        let xValues = trainingData.map { $0.x }
        let minX = xValues.min() ?? 0
        let maxX = xValues.max() ?? 0
        
        return [
            (x: minX, y: predict(minX)),
            (x: maxX, y: predict(maxX))
        ]
    }
}
