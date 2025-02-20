import SwiftUI

struct ModuleDropZone: View {
    let position: ModulePosition
    @ObservedObject var knnModel: KNNModel
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .stroke(style: StrokeStyle(lineWidth: 2, dash: [5]))
                .foregroundColor(.gray.opacity(0.5))
                .frame(width: 120, height: 100)
            
            if let module = knnModel.placedModules[position] {
                DraggableModule(type: module)
            } else {
                Text(dropZoneText)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding()
            }
        }
        .onDrop(of: [.text], delegate: ModuleDropDelegate(position: position, knnModel: knnModel))
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
}

struct ModuleDropDelegate: DropDelegate {
    let position: ModulePosition
    let knnModel: KNNModel
    
    func performDrop(info: DropInfo) -> Bool {
        guard let itemProvider = info.itemProviders(for: [.text]).first else {
            return false
        }
        
        itemProvider.loadObject(ofClass: NSString.self) { (reading, error) in
            DispatchQueue.main.async {
                if let moduleTypeString = reading as? String,
                   let moduleType = ModuleType(rawValue: moduleTypeString) {
                    knnModel.placeModule(moduleType, at: position)
                }
            }
        }
        
        return true
    }
    
    func validateDrop(info: DropInfo) -> Bool {
        guard let itemProvider = info.itemProviders(for: [.text]).first else {
            return false
        }
        
        var isValid = false
        let group = DispatchGroup()
        group.enter()
        
        itemProvider.loadObject(ofClass: NSString.self) { (reading, error) in
            if let moduleTypeString = reading as? String,
               let moduleType = ModuleType(rawValue: moduleTypeString) {
                isValid = knnModel.canPlace(moduleType, at: position)
            }
            group.leave()
        }
        
        group.wait()
        return isValid
    }
}