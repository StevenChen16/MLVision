import SwiftUI

struct ModuleDropZone: View {
    let position: ModulePosition
    @ObservedObject var knnModel: KNNModel
    @State private var isHighlighted = false
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .stroke(style: StrokeStyle(lineWidth: isHighlighted ? 2 : 1, dash: [5]))
                .foregroundColor(strokeColor)
                .frame(maxWidth: .infinity)
                .frame(height: 80)
                .background(backgroundColor)
            
            if let module = knnModel.placedModules[position] {
                DraggableModule(type: module)
                    .scaleEffect(knnModel.currentModuleAnimation == position ? 1.1 : 1.0)
                    .animation(.spring(), value: knnModel.currentModuleAnimation)
            } else {
                VStack(spacing: 8) {
                    Text(dropZoneText)
                        .font(.caption)
                        .foregroundColor(.gray.opacity(0.6))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 8)
                    
                    if let prerequisite = prerequisiteText {
                        Text(prerequisite)
                            .font(.caption2)
                            .foregroundColor(.red.opacity(0.8))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 8)
                    }
                }
            }
        }
        .onDrop(of: [.text], delegate: ModuleDropDelegate(position: position, knnModel: knnModel, isHighlighted: $isHighlighted))
    }
    
    private var strokeColor: Color {
        if knnModel.currentModuleAnimation == position {
            return .green
        } else if isHighlighted {
            return .blue
        } else {
            return .gray.opacity(0.5)
        }
    }
    
    private var backgroundColor: Color {
        if isHighlighted {
            return .blue.opacity(0.1)
        } else {
            return .clear
        }
    }
    
    private var dropZoneText: String {
        switch position {
        case .kValueSelector:
            return "Drop K-Value Selector here"
        case .distanceCalculator:
            return "Drop Distance Calculator here"
        case .classifier:
            return "Drop Classifier here"
        }
    }
    
    private var prerequisiteText: String? {
        switch position {
        case .kValueSelector:
            return nil
        case .distanceCalculator:
            return knnModel.placedModules[.kValueSelector] == nil ? "Requires K-Value Selector" : nil
        case .classifier:
            return knnModel.placedModules[.distanceCalculator] == nil ? "Requires Distance Calculator" : nil
        }
    }
}

struct ModuleDropDelegate: DropDelegate {
    let position: ModulePosition
    let knnModel: KNNModel
    @Binding var isHighlighted: Bool
    
    func performDrop(info: DropInfo) -> Bool {
        guard let itemProvider = info.itemProviders(for: [.text]).first else {
            return false
        }
        
        itemProvider.loadObject(ofClass: NSString.self) { (reading, error) in
            if let moduleTypeString = reading as? String,
               let moduleType = ModuleType(rawValue: moduleTypeString) {
                Task { @MainActor in
                    if knnModel.canPlace(moduleType, at: position) {
                        knnModel.placeModule(moduleType, at: position)
                        // Play haptic feedback
                        let generator = UIImpactFeedbackGenerator(style: .medium)
                        generator.impactOccurred()
                    }
                }
            }
        }
        return true
    }
    
    func validateDrop(info: DropInfo) -> Bool {
        guard let itemProvider = info.itemProviders(for: [.text]).first else {
            return false
        }
        
        // Simplify validation logic
        return knnModel.placedModules[position] == nil
    }
    
    func dropEntered(info: DropInfo) {
        isHighlighted = true
        // Add haptic feedback
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.prepare()
        generator.impactOccurred()
    }
    
    func dropExited(info: DropInfo) {
        isHighlighted = false
    }
    
    func dropUpdated(info: DropInfo) -> DropProposal? {
        return DropProposal(operation: .move)
    }
}