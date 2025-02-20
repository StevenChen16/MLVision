import SwiftUI

struct DraggableModule: View {
    let type: ModuleType
    @State private var isDragging = false
    
    var body: some View {
        VStack {
            Image(systemName: moduleIcon(for: type))
                .font(.system(size: 30))
            Text(type.rawValue)
                .font(.caption)
        }
        .frame(width: 100, height: 80)
        .background(Color.blue.opacity(0.1))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.blue, lineWidth: isDragging ? 2 : 1)
        )
        .shadow(radius: isDragging ? 10 : 0)
        .scaleEffect(isDragging ? 1.05 : 1.0)
        .onDrag {
            self.isDragging = true
            return NSItemProvider(object: type.rawValue as NSString)
        }
        .animation(.spring(), value: isDragging)
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