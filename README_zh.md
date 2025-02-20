# ML Algorithm Learning App

一个交互式的机器学习算法学习应用，专为Apple Student Challenge设计。通过直观的可视化和交互式操作，帮助用户理解机器学习算法的工作原理。

## 项目特点

- 📱 使用SwiftUI构建的现代化界面
- 🎯 交互式学习体验
- 🔍 实时可视化算法执行过程
- 🧩 模块化设计，支持拖放操作
- 📊 直观的数据可视化

## 当前功能

### KNN（K-最近邻）算法
- 实时数据点可视化
- 可调节的K值参数（1-10）
- 动态展示最近邻点
- 实时分类效果
- 随机数据生成

## 项目结构

```
MLAlgorithm/
├── App/
│   └── MLAlgorithmLearningApp.swift    # 应用程序入口
├── Models/
│   ├── DataPoints.swift                # 数据点模型
│   ├── KNNModel.swift                  # KNN算法实现
│   └── ModuleType.swift                # 模块类型定义
├── Views/
│   ├── Components/
│   │   └── ModuleDropZone.swift        # 模块放置区域
│   ├── ContentView.swift               # 主视图
│   ├── DraggableModule.swift           # 可拖动模块
│   ├── ToolboxView.swift              # 工具箱视图
│   └── VisualizationView.swift        # 可视化视图
└── Utils/
    ├── DataGenerator.swift             # 数据生成工具
    └── DistanceCalculator.swift        # 距离计算工具
```

## 技术特点

- **MVVM架构**: 清晰的代码结构和数据流
- **SwiftUI框架**: 现代化的声明式UI开发
- **响应式设计**: 实时更新的用户界面
- **模块化组件**: 可重用的UI组件

## 使用方法

1. 启动应用后，你会看到主界面分为工具箱和可视化区域
2. 使用滑块调整K值（1-10）
3. 观察数据点的分布和分类效果
4. 通过拖放模块学习算法的各个步骤

## 教育价值

- 直观理解KNN算法的工作原理
- 学习参数调整对算法的影响
- 理解机器学习中的分类问题
- 体验数据可视化的重要性

## 未来计划

- [ ] 添加更多机器学习算法
  - [ ] 线性回归
  - [ ] 决策树
  - [ ] 简单神经网络
- [ ] 增加算法执行步骤的详细解释
- [ ] 添加更多交互式教学元素
- [ ] 支持自定义数据集
- [ ] 添加算法性能指标
- [ ] 支持多语言本地化

## 系统要求

- iOS 15.0+
- Xcode 13.0+
- Swift 5.5+

## 作者

[你的名字]

## 许可证

该项目采用MIT许可证。详见LICENSE文件。
