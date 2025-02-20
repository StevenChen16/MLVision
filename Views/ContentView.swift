import SwiftUI

enum AlgorithmType {
    case knn, linearRegression, decisionTree
}

struct ContentView: View {
    @State private var selectedAlgorithm: AlgorithmType = .knn
    @StateObject private var knnModel = KNNModel()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // 算法选择器
                Picker("Algorithm", selection: $selectedAlgorithm) {
                    Text("KNN").tag(AlgorithmType.knn)
                    Text("Linear Regression").tag(AlgorithmType.linearRegression)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                // 算法视图
                switch selectedAlgorithm {
                case .knn:
                    HStack(spacing: 0) {
                        // 工具箱
                        ToolboxView()
                        
                        // 主要内容区域
                        VStack {
                            // 可视化区域
                            VisualizationView(knnModel: knnModel)
                                .padding()
                            
                            // 控制面板
                            ControlPanel(knnModel: knnModel)
                                .padding(.horizontal)
                                .padding(.bottom)
                        }
                    }
                case .linearRegression:
                    LinearRegressionView()
                case .decisionTree:
                    Text("Decision Tree - Coming Soon")
                }
            }
            .onAppear {
                // 生成初始数据
                let initialData = DataPoint.generateRandomPoints(
                    count: 20,
                    in: CGRect(x: -1, y: -1, width: 2, height: 2)
                )
                knnModel.setTrainingData(initialData)
            }
            .navigationTitle("ML Algorithm Learning")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        // 显示帮助信息
                    }) {
                        Image(systemName: "questionmark.circle")
                    }
                }
            }
        }
    }
}

struct ControlPanel: View {
    @ObservedObject var knnModel: KNNModel
    
    var body: some View {
        HStack {
            Text("K value: \(knnModel.k)")
            Slider(value: .init(
                get: { Double(knnModel.k) },
                set: { knnModel.setK(Int($0)) }
            ), in: 1...10, step: 1)
            .frame(width: 200)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
}

struct ModuleWorkspace: View {
    @ObservedObject var knnModel: KNNModel
    
    var body: some View {
        HStack(spacing: 20) {
            ForEach(ModulePosition.allCases, id: \.self) { position in
                ModuleDropZone(position: position, knnModel: knnModel)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
}
