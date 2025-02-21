import SwiftUI

struct InstructionsButton: View {
    let instructions: String
    @State private var showInstructions = false
    
    var body: some View {
        VStack {
            Button(action: {
                withAnimation {
                    showInstructions.toggle()
                }
            }) {
                HStack {
                    Image(systemName: "info.circle")
                    Text("Show Instructions")
                }
                .foregroundColor(.blue)
            }
            .buttonStyle(.bordered)
            
            if showInstructions {
                ScrollView {
                    Text(instructions)
                        .padding()
                        .background(Color.secondary.opacity(0.1))
                        .cornerRadius(8)
                }
                .transition(.move(edge: .top).combined(with: .opacity))
                .frame(maxHeight: 200)
            }
        }
        .padding(.horizontal)
    }
}
