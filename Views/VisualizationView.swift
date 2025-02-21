import SwiftUI

struct VisualizationView: View {
    @ObservedObject var knnModel: KNNModel
    @State private var viewSize: CGSize = .zero
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // 背景网格
                GridBackground()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                
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
                                 size: geometry.size,
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

struct ConnectionLines: View {
    let from: DataPoint
    let to: [DataPoint]
    let size: CGSize
    let converter: (DataPoint, CGSize) -> CGPoint
    
    var body: some View {
        ForEach(to, id: \.id) { point in
            Path { path in
                let start = converter(from, size)
                let end = converter(point, size)
                path.move(to: start)
                path.addLine(to: end)
            }
            .stroke(Color.gray.opacity(0.5), lineWidth: 1)
        }
    }
}