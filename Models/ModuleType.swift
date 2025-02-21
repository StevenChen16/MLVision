import Foundation

enum ModuleType: String, CaseIterable {
    case kValueSelector = "K Value Selector"
    case distanceCalculator = "Distance Calculator"
    case classifier = "Classifier"
    
    var id: String { self.rawValue }
    
    var description: String {
        switch self {
        case .kValueSelector:
            return "Select number of neighbors (K)"
        case .distanceCalculator:
            return "Calculate distances to all points"
        case .classifier:
            return "Classify based on nearest neighbors"
        }
    }
    
    var isConfigurable: Bool {
        switch self {
        case .kValueSelector:
            return true  // K值可以调整
        case .distanceCalculator, .classifier:
            return false
        }
    }
}