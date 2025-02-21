# ML Algorithm Learning App

An interactive machine learning algorithm learning application designed for the Apple Student Challenge. This app helps users understand machine learning algorithms through intuitive visualization and hands-on interaction.

## Key Features

- 📱 Modern interface built with SwiftUI
- 🎯 Interactive learning experience
- 🔍 Real-time algorithm visualization
- 🧩 Modular design with drag-and-drop support
- 📊 Intuitive data visualization

## Current Features

### KNN (K-Nearest Neighbors) Algorithm
- Interactive step-by-step demonstration of the KNN algorithm
- Manual control over animation steps with clear instructions
- Visualization of:
  - Training data points
  - Distance calculation to all points
  - K nearest neighbors selection
  - Final classification through voting
- Reset functionality to start over at any time

## Project Structure

```
MLAlgorithm/
├── App/
│   └── MLAlgorithmLearningApp.swift    # Application entry point
├── Models/
│   ├── DataPoints.swift                # Data point model
│   ├── KNNModel.swift                  # KNN algorithm implementation
│   └── ModuleType.swift                # Module type definitions
├── Views/
│   ├── Components/
│   │   └── ModuleDropZone.swift        # Module drop zone
│   ├── ContentView.swift               # Main view
│   ├── DraggableModule.swift           # Draggable module
│   ├── ToolboxView.swift               # Toolbox view
│   └── VisualizationView.swift         # Visualization view
└── Utils/
    ├── DataGenerator.swift             # Data generation utilities
    └── DistanceCalculator.swift        # Distance calculation utilities
```

## Technical Highlights

- **MVVM Architecture**: Clear code structure and data flow
- **SwiftUI Framework**: Modern declarative UI development
- **Reactive Design**: Real-time user interface updates
- **Modular Components**: Reusable UI components

## How to Use

1. Upon launching the app, you'll see the main interface divided into a toolbox and visualization area
2. Use the slider to adjust the K value (1-10)
3. Observe the distribution and classification effects of data points
4. Learn algorithm steps through module drag-and-drop interactions

## Educational Value

- Intuitive understanding of the KNN algorithm
- Learn how parameter adjustments affect algorithm performance
- Understand classification problems in machine learning
- Experience the importance of data visualization

## Future Plans

- [ ] Add more machine learning algorithms
  - [ ] Linear Regression
  - [ ] Decision Trees
  - [ ] Simple Neural Networks
- [ ] Add detailed explanations for algorithm steps
- [ ] Include more interactive learning elements
- [ ] Support custom datasets
- [ ] Add algorithm performance metrics
- [ ] Support localization

## System Requirements

- iOS 15.0+
- Xcode 13.0+
- Swift 5.5+

## Author

[Your Name]

## License

This project is licensed under the MIT License. See the LICENSE file for details.

## Language Support

This project supports both English and Chinese. For Chinese documentation, please refer to [README_zh.md](README_zh.md).
