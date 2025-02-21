import SwiftUI

struct GridBackground: View {
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let stepX = geometry.size.width / 10
                let stepY = geometry.size.height / 10
                
                // Draw vertical lines
                for i in 0...10 {
                    let x = CGFloat(i) * stepX
                    path.move(to: CGPoint(x: x, y: 0))
                    path.addLine(to: CGPoint(x: x, y: geometry.size.height))
                }
                
                // Draw horizontal lines
                for i in 0...10 {
                    let y = CGFloat(i) * stepY
                    path.move(to: CGPoint(x: 0, y: y))
                    path.addLine(to: CGPoint(x: geometry.size.width, y: y))
                }
            }
            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
        }
    }
}
