import SwiftUI
import Foundation

struct LinearRegressionView: View {
    @StateObject private var model = LinearRegressionModel()
    @State private var showingExplanation = false
    
    var body: some View {
        VStack {
            MainLinearRegressionContent(model: model)
                .padding()
            
            Button("Show Explanation") {
                showingExplanation = true
            }
            .sheet(isPresented: $showingExplanation) {
                AlgorithmExplanationView(viewModel: AlgorithmExplanationViewModel(algorithmType: .linearRegression))
            }
        }
    }
}

struct MainLinearRegressionContent: View {
    @ObservedObject var model: LinearRegressionModel
    
    var body: some View {
        VStack(spacing: 16) {
            // Instructions
            Text(model.instructions)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(8)
            
            HStack {
                LinearRegressionPlotView(model: model)
                
                VStack {
                    LinearRegressionControlPanel(model: model)
                    LinearRegressionInfoPanel(model: model)
                }
                .frame(width: 250)
            }
            
            // Step description
            Text(model.stepDescription)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.green.opacity(0.1))
                .cornerRadius(8)
        }
    }
}

struct LinearRegressionPlotView: View {
    @ObservedObject var model: LinearRegressionModel
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                SharedGridBackground()
                
                // Plot regression line
                if !model.trainingData.isEmpty {
                    Path { path in
                        let startPoint = model.convertToViewSpace(modelX: -1, modelY: model.predict(-1), viewSize: geometry.size)
                        let endPoint = model.convertToViewSpace(modelX: 1, modelY: model.predict(1), viewSize: geometry.size)
                        path.move(to: startPoint)
                        path.addLine(to: endPoint)
                    }
                    .stroke(Color.blue, lineWidth: 2)
                    
                    // 显示误差线
                    if model.showErrorLines {
                        ForEach(model.trainingData) { point in
                            let actualPoint = model.convertToViewSpace(modelX: point.x, modelY: point.y, viewSize: geometry.size)
                            let predictedY = model.predict(point.x)
                            let predictedPoint = model.convertToViewSpace(modelX: point.x, modelY: predictedY, viewSize: geometry.size)
                            
                            Path { path in
                                path.move(to: actualPoint)
                                path.addLine(to: predictedPoint)
                            }
                            .stroke(Color.red, style: StrokeStyle(lineWidth: 1, dash: [4]))
                        }
                    }
                    
                    // 显示梯度箭头
                    if model.showGradientArrows {
                        ForEach(model.trainingData) { point in
                            let position = model.convertToViewSpace(modelX: point.x, modelY: point.y, viewSize: geometry.size)
                            
                            Path { path in
                                path.move(to: position)
                                path.addLine(to: CGPoint(x: position.x, y: position.y - 20))
                            }
                            .stroke(Color.green, lineWidth: 2)
                        }
                    }
                }
                
                // Plot data points
                ForEach(model.trainingData) { point in
                    let position = model.convertToViewSpace(modelX: point.x, modelY: point.y, viewSize: geometry.size)
                    Circle()
                        .fill(Color.red)
                        .frame(width: 8, height: 8)
                        .position(position)
                }
            }
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        let point = model.convertToModelSpace(
                            viewX: value.location.x,
                            viewY: value.location.y,
                            viewSize: geometry.size
                        )
                        model.selectedPoint = RegressionDataPoint(x: point.x, y: point.y)
                    }
                    .onEnded { _ in
                        if let point = model.selectedPoint {
                            model.addPoint(point.x, point.y)
                            model.selectedPoint = nil
                        }
                    }
            )
        }
        .aspectRatio(1, contentMode: .fit)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}

struct LinearRegressionControlPanel: View {
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
                Slider(
                    value: .init(
                        get: { Double(model.epochs) },
                        set: { model.epochs = Int($0) }
                    ),
                    in: 10...1000,
                    step: 10
                )
                Text("\(model.epochs)")
            }
            
            HStack {
                Button("Next Step") {
                    Task {
                        await model.trainStep()
                    }
                }
                .disabled(model.isTraining || model.trainingData.isEmpty)
                
                Button("Auto Train") {
                    Task {
                        await model.train()
                    }
                }
                .disabled(model.isTraining || model.trainingData.isEmpty)
            }
            
            HStack {
                Button("Stop") {
                    model.stopTraining()
                }
                .disabled(!model.isTraining)
                
                Button("Clear") {
                    model.clearData()
                }
                .disabled(model.isTraining)
            }
        }
        .padding()
    }
}

struct LinearRegressionInfoPanel: View {
    @ObservedObject var model: LinearRegressionModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Model Parameters:")
                .font(.headline)
            Text("Slope: \(String(format: "%.4f", model.slope))")
            Text("Intercept: \(String(format: "%.4f", model.intercept))")
            Text("Error: \(String(format: "%.4f", model.error))")
            
            if model.isTraining {
                Text("Training... Epoch \(model.currentEpoch)/\(model.epochs)")
                ProgressView(value: Double(model.currentEpoch), total: Double(model.epochs))
            }
        }
        .padding()
    }
}

struct SharedGridBackground: View {
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
