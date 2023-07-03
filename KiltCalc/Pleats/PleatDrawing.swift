import SwiftUI

private struct MyPoint {
  let x: Double
  let y: Double
}

struct Pleaty: Shape {
  static let gap = CGFloat(20)
  static let previousPleat = CGFloat(75)
  static let pleatHeight = CGFloat(50)

  func path(in rect: CGRect) -> Path {
    var path = Path()

    path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
    path.addLine(to: CGPoint(x: rect.midX - Self.gap, y: rect.maxY))
    path.addLine(to: CGPoint(x: rect.minX + Self.previousPleat, y: rect.minY))
    path.addLine(to: CGPoint(x: rect.maxX - Self.previousPleat, y: rect.minY))
    path.addLine(to: CGPoint(x: rect.midX + Self.gap, y: rect.maxY))
    path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
    return path
  }
}

struct Guideline: Shape {
  let length: CGFloat

  let height = CGFloat(10)

  func path(in rect: CGRect) -> Path {
    var path = Path()

    path.move(to: CGPoint(x: rect.midX - length / 2, y: rect.midY))
    path.addLine(to: CGPoint(x: rect.midX + length / 2, y: rect.midY))

    return path
  }
}

struct PleatDrawing: View {
  fileprivate let size = MyPoint(x: 100, y: 200)

  var body: some View {
    VStack(alignment: .center) {
      Text("2 in")
      Text("pleat")
      Guideline(length: 240.0)
        .stroke(Color.blue, lineWidth: 3)
        .frame(height: 10)
      Pleaty()
        .stroke(Color.green, lineWidth: 4.0)
        .frame(height: Pleaty.pleatHeight)
      Guideline(length: Pleaty.gap)
        .stroke(Color.blue, lineWidth: 3)
        .frame(height: 20)
      Text("gap")
      Text("0 in")
    }
  }
}

struct PleatDrawing_Previews: PreviewProvider {
    static var previews: some View {
      PleatDrawing()
    }
}
