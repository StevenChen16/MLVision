import SwiftUI

struct KNNMainView: View {
    @ObservedObject var knnModel: KNNModel
    
    var body: some View {
        VStack(spacing: 20) {
            // Visualization area
            VisualizationView(knnModel: knnModel)
                .frame(maxWidth: .infinity)
                .frame(height: 300)
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 2)
                .padding(.horizontal)
            
            // Toolbox and drop zones
            HStack(alignment: .top, spacing: 20) {
                // Left toolbox
                VStack(alignment: .leading, spacing: 8) {
                    Text("Toolbox")
                        .font(.headline)
                    ToolboxView()
                }
                .frame(width: 150)
                .padding()
                .background(Color.secondary.opacity(0.05))
                .cornerRadius(10)
                
                // Drop zones
                VStack(spacing: 20) {
                    ModuleDropZone(position: .kValueSelector, knnModel: knnModel)
                    ModuleDropZone(position: .distanceCalculator, knnModel: knnModel)
                    ModuleDropZone(position: .classifier, knnModel: knnModel)
                }
                .frame(maxWidth: .infinity)
            }
            .padding(.horizontal)
            
            // Bottom control panel
            KNNControlPanel(knnModel: knnModel)
                .padding(.horizontal)
        }
        .padding(.vertical)
    }
}
