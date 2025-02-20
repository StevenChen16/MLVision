import SwiftUI

struct AlgorithmStep: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let image: String?
}

class AlgorithmExplanationViewModel: ObservableObject {
    @Published var currentStep: Int = 0
    @Published var steps: [AlgorithmStep] = []
    
    init(algorithmType: AlgorithmType) {
        setupSteps(for: algorithmType)
    }
    
    private func setupSteps(for algorithmType: AlgorithmType) {
        switch algorithmType {
        case .knn:
            steps = [
                AlgorithmStep(
                    title: "1. Data Collection",
                    description: "KNN starts with a dataset of points where each point has known features and a class label. These points form our training data.",
                    image: "data.collection"
                ),
                AlgorithmStep(
                    title: "2. Distance Calculation",
                    description: "When classifying a new point, KNN calculates the distance between this point and all points in the training set. Common distance metrics include Euclidean distance.",
                    image: "distance.calculation"
                ),
                AlgorithmStep(
                    title: "3. Finding K Nearest Neighbors",
                    description: "The algorithm then finds the K training points that are closest to the new point. The value of K is crucial - too small may lead to noise sensitivity, too large may include points from other classes.",
                    image: "nearest.neighbors"
                ),
                AlgorithmStep(
                    title: "4. Majority Voting",
                    description: "The new point is assigned to the class that appears most frequently among its K nearest neighbors. This is why KNN is considered a 'voting-based' classifier.",
                    image: "majority.voting"
                ),
                AlgorithmStep(
                    title: "5. Prediction Result",
                    description: "The final prediction is made based on the majority vote. In case of a tie, the algorithm typically chooses the class of the nearest neighbor.",
                    image: "prediction.result"
                )
            ]
        case .linearRegression:
            // To be implemented
            break
        case .decisionTree:
            // To be implemented
            break
        }
    }
    
    func nextStep() {
        if currentStep < steps.count - 1 {
            currentStep += 1
        }
    }
    
    func previousStep() {
        if currentStep > 0 {
            currentStep -= 1
        }
    }
}

struct AlgorithmExplanationView: View {
    @StateObject var viewModel: AlgorithmExplanationViewModel
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: 20) {
            // Progress indicator
            ProgressView(value: Double(viewModel.currentStep + 1), total: Double(viewModel.steps.count))
                .padding(.horizontal)
            
            if !viewModel.steps.isEmpty {
                let step = viewModel.steps[viewModel.currentStep]
                
                // Step content
                VStack(alignment: .leading, spacing: 15) {
                    Text(step.title)
                        .font(.title2)
                        .bold()
                    
                    Text(step.description)
                        .font(.body)
                        .foregroundColor(.secondary)
                    
                    if let imageName = step.image {
                        Image(systemName: imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 100)
                            .foregroundColor(.accentColor)
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(colorScheme == .dark ? Color.black : Color.white)
                        .shadow(radius: 5)
                )
                
                // Navigation buttons
                HStack {
                    Button(action: viewModel.previousStep) {
                        Image(systemName: "chevron.left")
                            .imageScale(.large)
                    }
                    .disabled(viewModel.currentStep == 0)
                    
                    Spacer()
                    
                    Button(action: viewModel.nextStep) {
                        Image(systemName: "chevron.right")
                            .imageScale(.large)
                    }
                    .disabled(viewModel.currentStep == viewModel.steps.count - 1)
                }
                .padding(.horizontal, 40)
            }
        }
        .padding()
    }
}

enum AlgorithmType {
    case knn
    case linearRegression
    case decisionTree
}
