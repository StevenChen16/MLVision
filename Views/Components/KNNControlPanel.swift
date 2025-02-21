import SwiftUI

struct KNNControlPanel: View {
    @ObservedObject var knnModel: KNNModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Instructions")
                .font(.headline)
            
            Text(knnModel.moduleInstructions)
                .font(.body)
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color.secondary.opacity(0.05))
                .cornerRadius(8)
            
            if knnModel.placedModules[.kValueSelector] != nil {
                VStack(alignment: .leading, spacing: 8) {
                    Text("K Value: \(knnModel.k)")
                        .font(.subheadline)
                    
                    Slider(value: .init(
                        get: { Double(knnModel.k) },
                        set: { knnModel.setK(Int($0)) }
                    ), in: 1...10, step: 1)
                }
                .padding(.top, 8)
            }
        }
    }
}
