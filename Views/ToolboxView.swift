import SwiftUI

struct ToolboxView: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("Algorithm Components")
                .font(.headline)
                .padding(.bottom, 8)
            
            VStack(spacing: 12) {
                DraggableModule(type: .kValueSelector)
                    .help("""
                        K-Value Selector
                        • Controls the number of neighbors
                        • Drag this module first
                        • Essential for KNN algorithm
                    """)
                
                DraggableModule(type: .distanceCalculator)
                    .help("""
                        Distance Calculator
                        • Measures point distances
                        • Requires K-Value Selector
                        • Helps find nearest neighbors
                    """)
                
                DraggableModule(type: .classifier)
                    .help("""
                        Classifier
                        • Makes final predictions
                        • Uses nearest neighbors
                        • Completes the algorithm
                    """)
            }
            
            Spacer()
            
            Text("Drag modules to build\nthe KNN algorithm")
                .font(.caption)
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
        }
    }
}