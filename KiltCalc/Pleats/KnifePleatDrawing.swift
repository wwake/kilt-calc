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
  var pleat: CGFloat
  var gap: CGFloat

  var body: some View {
    VStack(alignment: .center) {
      Text("pleat")

      DimensionLine()
        .frame(width: pleat, height: 10)
        .padding([.bottom], 8)

      KnifePleatShape(pleat: pleat)
        .stroke(Color.green, lineWidth: 4.0)
        .frame(height: 50)
    }
  }
}

struct KnifePleatDrawing_Previews: PreviewProvider {
  static var previews: some View {
    KnifePleatDrawing(pleat: 150, gap: 22)
  }
}
