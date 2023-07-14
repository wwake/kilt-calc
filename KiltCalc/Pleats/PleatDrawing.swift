import SwiftUI

extension Shape {
  func flipped() -> ScaledShape<Self> {
    scale(x: -1, y: 1, anchor: .center)
  }
}

private struct BoxPleatShape: Shape {
  var pleat: CGFloat
  var gap: CGFloat

  func path(in rect: CGRect) -> Path {
    var path = Path()

    path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
    path.addLine(to: CGPoint(x: rect.midX - gap / 2, y: rect.maxY))
    path.addLine(to: CGPoint(x: rect.midX - pleat / 2, y: rect.minY))
    path.addLine(to: CGPoint(x: rect.midX + pleat / 2, y: rect.minY))
    path.addLine(to: CGPoint(x: rect.midX + gap / 2, y: rect.maxY))
    path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
    return path
  }
}

private struct DimensionLine: View {
  var color: Color

  init(_ color: Color = Color.cyan) {
    self.color = color
  }

  var body: some View {
    DoubleArrow(color: color)
      .frame(height: 10)
      .overlay(
        VerticalLine()
          .stroke(color, lineWidth: 2)
          .frame(height: 24)
      )
      .overlay(
        VerticalLine().flipped()
          .stroke(color, lineWidth: 2)
          .frame(height: 24)
      )
  }
}

private struct DoubleArrow: View {
  var color: Color

  var body: some View {
    HorizontalLine()
      .stroke(color, lineWidth: 2)
      .overlay(
        ArrowHead()
          .stroke(color, lineWidth: 2)
      )
      .overlay(
        ArrowHead()
          .flipped()
          .stroke(color, lineWidth: 2)
      )
  }
}

private struct ArrowHead: Shape {
  func path(in rect: CGRect) -> Path {
    var path = Path()

    let arrowWidth = rect.height
    if arrowWidth >= rect.width / 2 {
      return path
    }

    path.move(to: CGPoint(x: rect.minX + arrowWidth, y: rect.minY))

    path.addLine(to: CGPoint(x: rect.minX, y: rect.midY))

    path.addLine(to: CGPoint(x: rect.minX + arrowWidth, y: rect.maxY))

    return path
  }
}

private struct HorizontalLine: Shape {
  func path(in rect: CGRect) -> Path {
    var path = Path()
    path.move(to: CGPoint(x: rect.minX, y: rect.midY))
    path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
    return path
  }
}

private struct VerticalLine: Shape {
  func path(in rect: CGRect) -> Path {
    var path = Path()
    path.move(to: CGPoint(x: rect.minX, y: rect.minY))
    path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
    return path
  }
}

struct BoxPleatDrawing: View {
  var pleat: CGFloat
  var gap: CGFloat

  var body: some View {
    VStack(alignment: .center) {
      // Text("2 in")
      Text("pleat")

      DimensionLine()
        .frame(width: pleat, height: 10)
        .padding([.bottom], 8)

      BoxPleatShape(pleat: pleat, gap: gap)
        .stroke(Color.green, lineWidth: 4.0)
        .frame(height: 50)

      DimensionLine()
        .frame(width: gap, height: 10)
        .padding([.top], 8)

      Text("gap")
      // Text("0 in")
    }
    .padding()
  }
}

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
      // Text("2 in")
      Text("pleat")

      DimensionLine()
        .frame(width: pleat, height: 10)
        .padding([.bottom], 8)

      KnifePleatShape(pleat: pleat)
        .stroke(Color.green, lineWidth: 4.0)
        .frame(height: 50)
    }
    .padding()
  }
}

struct PleatDrawing_Previews: PreviewProvider {
  static var previews: some View {
    VStack {
      Spacer()
      BoxPleatDrawing(pleat: 150, gap: 22)
      Spacer()
      KnifePleatDrawing(pleat: 150, gap: 22)
      Spacer()
    }
  }
}
