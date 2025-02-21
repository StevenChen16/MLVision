import SwiftUI

struct VisualizationView: View {
    @ObservedObject var knnModel: KNNModel
    @State private var viewSize: CGSize = .zero
    
    var body: some View {
        VStack(spacing: 0) {
            // Step description text
            Text(knnModel.getStepDescription())
                .font(.headline)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .shadow(radius: 1)
            
            GeometryReader { geometry in
                ZStack {
                    // Background grid
                    GridBackground()
                        .frame(width: geometry.size.width, height: geometry.size.height)
                    
                    // Training data points
                    ForEach(knnModel.trainingData) { point in
                        Circle()
                            .fill(categoryColor(for: point.category))
                            .frame(width: 10, height: 10)
                            .position(convertToView(point: point, in: geometry.size))
                            .opacity(knnModel.nearestNeighbors.contains(point) ? 1.0 : 0.6)
                    }
                    
                    // Demo point
                    if let demo = knnModel.demoPoint {
                        Circle()
                            .fill(categoryColor(for: demo.category))
                            .frame(width: 12, height: 12)
                            .position(convertToView(point: demo, in: geometry.size))
                            .overlay(
                                Circle()
                                    .stroke(Color.black, lineWidth: 2)
                                    .frame(width: 14, height: 14)
                            )
                            .opacity(knnModel.animationStep > 0 ? 1.0 : 0.0)
                    }
                    
                    // Connection lines (when a point is selected)
                    if let selected = knnModel.selectedPoint {
                        ConnectionLines(from: selected,
                                     to: knnModel.nearestNeighbors,
                                     size: geometry.size,
                                     converter: convertToView)
                    }
                }
                .onAppear {
                    viewSize = geometry.size
                    // Start demo animation when all modules are placed
                    if knnModel.placedModules[.classifier] != nil && !knnModel.isAnimating {
                        knnModel.startDemoAnimation()
                    }
                }
                .onChange(of: geometry.size) { newSize in
                    viewSize = newSize
                }
                .onChange(of: knnModel.placedModules) { modules in
                    // Start demo animation when the last module is placed
                    if modules[.classifier] != nil && !knnModel.isAnimating {
                        knnModel.startDemoAnimation()
                    }
                }
            }
            
            // Control buttons
            HStack(spacing: 20) {
                Button(action: {
                    knnModel.reset()
                }) {
                    Label("Reset", systemImage: "arrow.counterclockwise")
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                
                Button(action: {
                    knnModel.previousStep()
                }) {
                    Label("Previous", systemImage: "chevron.left")
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(knnModel.animationStep > 0 ? Color.blue : Color.gray)
                        .cornerRadius(8)
                }
                .disabled(knnModel.animationStep == 0)
                
                Button(action: {
                    knnModel.nextStep()
                }) {
                    Label("Next", systemImage: "chevron.right")
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(knnModel.animationStep < 4 ? Color.blue : Color.gray)
                        .cornerRadius(8)
                }
                .disabled(knnModel.animationStep == 4)
            }
            .padding()
            .background(Color.white)
            .shadow(radius: 1)
        }
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 2)
    }
    
    // Convert data point coordinates to view coordinates
    private func convertToView(point: DataPoint, in size: CGSize) -> CGPoint {
        CGPoint(
            x: (point.x + 1) * size.width / 2,
            y: (point.y + 1) * size.height / 2
        )
    }
    
    // Get color based on point category
    private func categoryColor(for category: Int) -> Color {
        switch category {
        case 0: return .blue
        case 1: return .red
        default: return .gray
        }
    }
}

// View for drawing connection lines between points
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