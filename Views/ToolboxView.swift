import SwiftUI

struct ToolboxView: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("Toolbox")
                .font(.headline)
                .padding(.top)
            
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(ModuleType.allCases) { moduleType in
                        DraggableModule(type: moduleType)
                    }
                }
                .padding()
            }
        }
        .frame(width: 150)
        .background(Color.gray.opacity(0.1))
    }
}