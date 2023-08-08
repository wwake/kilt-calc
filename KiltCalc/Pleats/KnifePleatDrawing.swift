import SwiftUI

private struct KnifePleatShape: Shape {
  var pleat: CGFloat

  func path(in rect: CGRect) -> Path {
    let leftPleat = rect.midX - pleat / 2
    let rightPleat = leftPleat + pleat

    var path = Path()
    path.move(to: CGPoint(x: rect.minX, y: rect.midY))
    path.addLine(to: CGPoint(x: leftPleat, y: rect.minY))
    path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
    path.addLine(to: CGPoint(x: rightPleat, y: rect.minY))
    path.addLine(to: CGPoint(x: leftPleat, y: rect.maxY))
    path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
    path.addLine(to: CGPoint(x: rightPleat, y: rect.maxY))
    return path
  }
}

struct KnifePleatDrawing: View {
  let pleatPixels: CGFloat = 125
  var depthText: String

  var body: some View {
    GeometryReader { geometry in
      VStack(alignment: .leading) {
        VStack(alignment: .center) {
          DimensionLine()
            .frame(width: pleatPixels, height: 10)
            .padding([.bottom], 8)

          KnifePleatShape(pleat: pleatPixels)
            .stroke(Color.green, lineWidth: 4.0)
            .frame(height: 50)
        }

        DimensionLine()
          .frame(width: geometry.size.width / 2 - pleatPixels / 2)
          .frame(height: 10)
          .padding([.top], 8)
        Text("Depth: \(depthText)")
          .padding([.top], 4)
          .padding([.leading], 8)
      }
    }
    .frame(height: 150)
    .padding()
  }
}

struct KnifePleatDrawing_Previews: PreviewProvider {
  static var previews: some View {
    KnifePleatDrawing(depthText: "2 in")
  }
}
