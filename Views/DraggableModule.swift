import SwiftUI

struct DraggableModule: View {
    let type: ModuleType
    @State private var isDragging = false
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: moduleIcon(for: type))
                .font(.system(size: 28))
                .foregroundColor(.blue)
            Text(type.rawValue)
                .font(.system(size: 12))
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 70)
        .background(Color.blue.opacity(0.1))
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.blue.opacity(0.3), lineWidth: isDragging ? 2 : 1)
        )
        .shadow(radius: isDragging ? 5 : 0)
        .scaleEffect(isDragging ? 1.05 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: isDragging)
        .onDrag {
            self.isDragging = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.isDragging = false
            }
            return NSItemProvider(object: type.rawValue as NSString)
        }
    }
    
    private func moduleIcon(for type: ModuleType) -> String {
        switch type {
        case .kValueSelector:
            return "slider.horizontal.3"
        case .distanceCalculator:
            return "ruler"
        case .classifier:
            return "square.grid.2x2"
        }
    }
}