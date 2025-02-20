import SwiftUI

struct VisualizationView: View {
    @ObservedObject var knnModel: KNNModel
    @State private var viewSize: CGSize = .zero
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // 背景网格
                GridBackground()
                
                // 数据点
                ForEach(knnModel.trainingData) { point in
                    Circle()
                        .fill(categoryColor(for: point.category))
                        .frame(width: 10, height: 10)
                        .position(convertToView(point: point, in: geometry.size))
                        .opacity(knnModel.nearestNeighbors.contains(point) ? 1.0 : 0.6)
                }
                
                // 连接线（当有选中点时）
                if let selected = knnModel.selectedPoint {
                    ConnectionLines(from: selected,
                                 to: knnModel.nearestNeighbors,
                                 in: geometry.size,
                                 converter: convertToView)
                }
            }
            .onAppear {
                viewSize = geometry.size
            }
            .onChange(of: geometry.size) { newSize in
                viewSize = newSize
            }
        }
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 2)
    }
    
    private func convertToView(point: DataPoint, in size: CGSize) -> CGPoint {
        CGPoint(
            x: (point.x + 1) * size.width / 2,
            y: (point.y + 1) * size.height / 2
        )
    }
    
    private func categoryColor(for category: Int) -> Color {
        switch category {
        case 0: return .blue
        case 1: return .red
        default: return .gray
        }
    }
}

struct GridBackground: View {
    var body: some View {
        Path { path in
            let step: CGFloat = 0.1
            for x in stride(from: 0, through: 1, by: step) {
                path.move(to: CGPoint(x: x, y: 0))
                path.addLine(to: CGPoint(x: x, y: 1))
            }
            for y in stride(from: 0, through: 1, by: step) {
                path.move(to: CGPoint(x: 0, y: y))
                path.addLine(to: CGPoint(x: 1, y: y))
            }
        }
        .stroke(Color.gray.opacity(0.2), lineWidth: 0.5)
    }
}

struct ConnectionLines: View {
    let from: DataPoint
    let to: [DataPoint]
    let size: CGSize
    let converter: (DataPoint, CGSize) -> CGPoint
    
    var body: some View {
        Path { path in
            let fromPoint = converter(from, size)
            for neighbor in to {
                let toPoint = converter(neighbor, size)
                path.move(to: fromPoint)
                path.addLine(to: toPoint)
            }
        }
        .stroke(Color.gray.opacity(0.5), lineWidth: 1)
    }
}