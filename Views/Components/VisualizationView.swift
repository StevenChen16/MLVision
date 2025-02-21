import SwiftUI

struct VisualizationView: View {
    @ObservedObject var knnModel: KNNModel
    @GestureState private var isDragging = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background grid
                GridBackground()
                
                // Training data points
                ForEach(knnModel.trainingData, id: \.id) { point in
                    Circle()
                        .fill(point.category == 0 ? Color.blue : Color.red)
                        .frame(width: 12, height: 12)
                        .position(
                            x: point.x * geometry.size.width,
                            y: point.y * geometry.size.height
                        )
                        .opacity(knnModel.nearestNeighbors.contains(point) ? 0.8 : 0.5)
                        .scaleEffect(knnModel.nearestNeighbors.contains(point) ? 1.3 : 1.0)
                        .animation(.spring(), value: knnModel.nearestNeighbors)
                }
                
                // Selected point
                if let selectedPoint = knnModel.selectedPoint {
                    Circle()
                        .stroke(Color.purple, lineWidth: 2)
                        .frame(width: 16, height: 16)
                        .position(
                            x: selectedPoint.x * geometry.size.width,
                            y: selectedPoint.y * geometry.size.height
                        )
                }
            }
            .gesture(
                DragGesture(minimumDistance: 0)
                    .updating($isDragging) { _, state, _ in
                        state = true
                    }
                    .onEnded { value in
                        let point = DataPoint(
                            x: value.location.x / geometry.size.width,
                            y: value.location.y / geometry.size.height
                        )
                        if let category = knnModel.classify(point) {
                            point.category = category
                            knnModel.trainingData.append(point)
                        }
                    }
            )
        }
    }
}

struct GridBackground: View {
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                // Vertical lines
                for i in 0...10 {
                    let x = CGFloat(i) * geometry.size.width / 10
                    path.move(to: CGPoint(x: x, y: 0))
                    path.addLine(to: CGPoint(x: x, y: geometry.size.height))
                }
                
                // Horizontal lines
                for i in 0...10 {
                    let y = CGFloat(i) * geometry.size.height / 10
                    path.move(to: CGPoint(x: 0, y: y))
                    path.addLine(to: CGPoint(x: geometry.size.width, y: y))
                }
            }
            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
        }
    }
}
