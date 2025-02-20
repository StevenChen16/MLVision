import SwiftUI

struct LinearRegressionView: View {
    @StateObject private var model = LinearRegressionModel()
    @State private var showingExplanation = false
    
    var body: some View {
        VStack {
            // 图表区域
            RegressionPlot(model: model)
                .frame(height: 300)
                .padding()
            
            // 控制面板
            RegressionControlPanel(model: model)
            
            // 信息面板
            InfoPanel(model: model)
            
            // 操作按钮
            ButtonPanel(model: model, showingExplanation: $showingExplanation)
        }
        .sheet(isPresented: $showingExplanation) {
            AlgorithmExplanationView(viewModel: AlgorithmExplanationViewModel(algorithmType: .linearRegression))
        }
    }
}

struct RegressionPlot: View {
    @ObservedObject var model: LinearRegressionModel
    @GestureState private var dragLocation: CGPoint?
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // 绘制网格
                GridBackground()
                
                // 绘制数据点
                ForEach(model.trainingData, id: \.x) { point in
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 8, height: 8)
                        .position(
                            x: normalizeX(point.x, in: geometry.size),
                            y: normalizeY(point.y, in: geometry.size)
                        )
                }
                
                // 绘制回归线
                if !model.trainingData.isEmpty {
                    Path { path in
                        let points = model.getRegressionLinePoints()
                        let startPoint = CGPoint(
                            x: normalizeX(points[0].x, in: geometry.size),
                            y: normalizeY(points[0].y, in: geometry.size)
                        )
                        path.move(to: startPoint)
                        let endPoint = CGPoint(
                            x: normalizeX(points[1].x, in: geometry.size),
                            y: normalizeY(points[1].y, in: geometry.size)
                        )
                        path.addLine(to: endPoint)
                    }
                    .stroke(Color.red, lineWidth: 2)
                }
            }
            .gesture(
                DragGesture(minimumDistance: 0)
                    .updating($dragLocation) { value, state, _ in
                        state = value.location
                    }
                    .onEnded { value in
                        let point = convertToDataPoint(value.location, in: geometry.size)
                        model.addPoint(point.x, point.y)
                    }
            )
        }
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 5)
    }
    
    private func normalizeX(_ x: Double, in size: CGSize) -> CGFloat {
        let padding: CGFloat = 20
        return CGFloat(x) * (size.width - 2 * padding) + padding
    }
    
    private func normalizeY(_ y: Double, in size: CGSize) -> CGFloat {
        let padding: CGFloat = 20
        return size.height - (CGFloat(y) * (size.height - 2 * padding) + padding)
    }
    
    private func convertToDataPoint(_ point: CGPoint, in size: CGSize) -> (x: Double, y: Double) {
        let padding: CGFloat = 20
        let x = Double((point.x - padding) / (size.width - 2 * padding))
        let y = Double((size.height - point.y - padding) / (size.height - 2 * padding))
        return (x: x, y: y)
    }
}

struct GridBackground: View {
    var body: some View {
        Path { path in
            // Draw horizontal lines
            for i in 0...10 {
                let y = CGFloat(i) * 30.0
                path.move(to: CGPoint(x: 0, y: y))
                path.addLine(to: CGPoint(x: 1000, y: y))
            }
            
            // Draw vertical lines
            for i in 0...10 {
                let x = CGFloat(i) * 30.0
                path.move(to: CGPoint(x: x, y: 0))
                path.addLine(to: CGPoint(x: x, y: 1000))
            }
        }
        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
    }
}

struct RegressionControlPanel: View {
    @ObservedObject var model: LinearRegressionModel
    
    var body: some View {
        VStack(spacing: 15) {
            HStack {
                Text("Learning Rate:")
                Slider(value: $model.learningRate, in: 0.001...0.1)
                Text(String(format: "%.3f", model.learningRate))
            }
            
            HStack {
                Text("Epochs:")
                Slider(value: Double(binding: Binding(
                    get: { Double(model.epochs) },
                    set: { model.epochs = Int($0) }
                )), in: 10...1000, step: 10)
                Text("\(model.epochs)")
            }
        }
        .padding()
        .background(Color.secondary.opacity(0.1))
        .cornerRadius(12)
    }
}

struct InfoPanel: View {
    @ObservedObject var model: LinearRegressionModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Model Parameters:")
                .font(.headline)
            
            Text("Slope: \(String(format: "%.4f", model.slope))")
            Text("Intercept: \(String(format: "%.4f", model.intercept))")
            Text("MSE: \(String(format: "%.4f", model.error))")
            
            if model.isTraining {
                Text("Training Progress: \(model.currentEpoch)/\(model.epochs)")
                ProgressView(value: Double(model.currentEpoch), total: Double(model.epochs))
            }
        }
        .padding()
        .background(Color.secondary.opacity(0.1))
        .cornerRadius(12)
    }
}

struct ButtonPanel: View {
    @ObservedObject var model: LinearRegressionModel
    @Binding var showingExplanation: Bool
    
    var body: some View {
        HStack(spacing: 20) {
            Button(action: model.train) {
                Text("Train Model")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .disabled(model.isTraining || model.trainingData.isEmpty)
            
            Button(action: model.clearData) {
                Text("Clear Data")
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            
            Button(action: { showingExplanation.toggle() }) {
                Image(systemName: "info.circle")
                    .imageScale(.large)
                    .padding()
                    .background(Color.secondary.opacity(0.1))
                    .cornerRadius(8)
            }
        }
        .padding()
    }
}
