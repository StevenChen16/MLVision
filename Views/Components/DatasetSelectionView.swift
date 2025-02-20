import SwiftUI

struct DatasetSelectionView: View {
    let algorithmType: AlgorithmType
    @Binding var selectedDataset: Dataset?
    @Environment(\.presentationMode) var presentationMode
    
    private var datasets: [Dataset] {
        switch algorithmType {
        case .knn:
            return DatasetManager.shared.getDatasets(for: .classification)
        case .linearRegression:
            return DatasetManager.shared.getDatasets(for: .regression)
        case .decisionTree:
            return DatasetManager.shared.getDatasets(for: .classification)
        }
    }
    
    var body: some View {
        NavigationView {
            List(datasets, id: \.name) { dataset in
                DatasetCell(dataset: dataset)
                    .onTapGesture {
                        selectedDataset = dataset
                        presentationMode.wrappedValue.dismiss()
                    }
            }
            .navigationTitle("Select Dataset")
            .navigationBarItems(trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

struct DatasetCell: View {
    let dataset: Dataset
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(dataset.name)
                .font(.headline)
            
            Text(dataset.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            // 数据预览
            DatasetPreview(dataset: dataset)
                .frame(height: 100)
                .padding(.vertical, 4)
        }
        .padding(.vertical, 8)
    }
}

struct DatasetPreview: View {
    let dataset: Dataset
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // 背景网格
                GridBackground()
                
                // 数据点
                ForEach(dataset.data, id: \.id) { point in
                    Circle()
                        .fill(pointColor(for: point))
                        .frame(width: 6, height: 6)
                        .position(
                            x: point.x * geometry.size.width,
                            y: (1 - point.y) * geometry.size.height
                        )
                }
            }
        }
        .background(Color.white)
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
        )
    }
    
    private func pointColor(for point: DataPoint) -> Color {
        if dataset.type == .classification {
            return point.category == 0 ? .blue : .red
        } else {
            return .blue
        }
    }
}
