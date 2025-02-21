import SwiftUI
import Foundation

struct ContentView: View {
    @State private var selectedAlgorithm: AlgorithmType = .knn
    @StateObject private var knnModel = KNNModel()
    @StateObject private var audioPlayer = AudioPlayer()
    @State private var showHelp = false
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack(spacing: 0) {
                    // 添加顶部安全区域，考虑灵动岛的高度
                    Color.clear
                        .frame(height: geometry.safeAreaInsets.top + 60)  // 动态计算顶部安全区域加额外空间
                    
                    Text("Machine Learning Visualization")
                        .font(.headline)
                        .padding(.bottom, 8)
                    
                    // 算法选择器
                    Picker("Algorithm", selection: $selectedAlgorithm) {
                        Text("KNN").tag(AlgorithmType.knn)
                        Text("Linear Regression").tag(AlgorithmType.linearRegression)
                        Text("Decision Tree").tag(AlgorithmType.decisionTree)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)
                    .padding(.bottom, 8)
                    
                    // 算法视图
                    switch selectedAlgorithm {
                    case .knn:
                        KNNMainView(knnModel: knnModel)
                    case .linearRegression:
                        LinearRegressionView()
                    case .decisionTree:
                        VStack {
                            Image(systemName: "hammer.fill")
                                .font(.system(size: 50))
                                .foregroundColor(.gray)
                                .padding()
                            Text("Coming Soon!")
                                .font(.title)
                            Text("This feature is under development")
                                .foregroundColor(.gray)
                            InstructionsButton(instructions: """
                                Decision Tree Algorithm
                                
                                Coming Soon!
                                
                                Decision trees are a powerful and intuitive machine learning algorithm
                                that makes decisions by following a tree-like structure of rules.
                                
                                This module is currently under development.
                                Stay tuned for updates!
                                
                                Key Features to Come:
                                • Visual tree structure representation
                                • Step-by-step decision process
                                • Interactive node splitting
                                • Real-time prediction paths
                                • Pruning visualization
                                
                                We're working hard to bring you an amazing
                                learning experience with decision trees!
""")
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.secondary.opacity(0.1))
                    }
                }
                .edgesIgnoringSafeArea(.top)  // 忽略顶部安全区域，使用我们自己的间距
            }
            .navigationBarHidden(true)  // 隐藏导航栏，完全自己控制布局
            .onAppear {
                // 生成初始数据
                let initialData = DataPoint.generateRandomPoints(
                    count: 20,
                    in: CGRect(x: -1, y: -1, width: 2, height: 2)
                )
                knnModel.setTrainingData(initialData)
                
                // 开始播放音乐
                audioPlayer.play()
            }
            .navigationBarItems(trailing: HStack {
                Button(action: {
                    audioPlayer.toggle()
                }) {
                    Image(systemName: audioPlayer.isPlaying ? "speaker.wave.2.fill" : "speaker.slash.fill")
                }
                .help("Toggle background music")
                
                Button(action: {
                    showHelp = true
                }) {
                    Image(systemName: "questionmark.circle")
                }
                .help("Show help information")
            })
            .sheet(isPresented: $showHelp) {
                AlgorithmHelpView(algorithmType: selectedAlgorithm)
            }
        }
    }
}

struct AlgorithmHelpView: View {
    let algorithmType: AlgorithmType
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    switch algorithmType {
                    case .knn:
                        Text("""
                            K-Nearest Neighbors (KNN) Algorithm
                            
                            What is KNN?
                            KNN is a simple yet powerful classification algorithm that makes predictions based on the 'k' closest data points in the training set.
                            
                            How to Use This Demo:
                            1. Drag and Drop Modules:
                                • Start with the K-Value Selector
                                • Add the Distance Calculator
                                • Finally, place the Classifier
                            
                            2. Interact with Data:
                                • Click anywhere to add data points
                                • Use the K-value slider to adjust neighbors
                                • Watch how classification changes
                            
                            Key Concepts:
                            • K-Value: The number of neighbors to consider
                            • Distance: How far points are from each other
                            • Classification: Determining a point's category
                            
                            Tips:
                            • Try different K values to see how it affects classification
                            • Add points in clear patterns for better understanding
                            • Watch how the decision boundary changes
""")
                    case .linearRegression:
                        Text("""
                            Linear Regression Algorithm
                            
                            What is Linear Regression?
                            Linear regression finds the best-fitting straight line through your data points, helping predict future values.
                            
                            How to Use This Demo:
                            1. Add Data Points:
                                • Click on the graph to add points
                                • Try to create a linear pattern
                            
                            2. Train the Model:
                                • Use 'Next Step' to learn step-by-step
                                • Or use 'Auto Train' for quick results
                            
                            3. Adjust Parameters:
                                • Learning Rate: Controls step size
                                • Epochs: Number of training iterations
                            
                            Key Concepts:
                            • Slope: Steepness of the line
                            • Intercept: Where line crosses Y-axis
                            • Error: Distance between predictions and actual values
                            • Gradient: Direction to adjust parameters
                            
                            Tips:
                            • Start with a small learning rate
                            • Add more points for better accuracy
                            • Watch how the line adjusts to fit data
""")
                    case .decisionTree:
                        Text("""
                            Decision Tree Algorithm
                            
                            Coming Soon!
                            
                            Decision trees are a powerful and intuitive machine learning algorithm
                            that makes decisions by following a tree-like structure of rules.
                            
                            This module is currently under development.
                            Stay tuned for updates!
""")
                    }
                }
                .padding()
                .font(.body)
            }
            .navigationTitle("How to Use")
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}
