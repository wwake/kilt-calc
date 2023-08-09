import SwiftUI

private struct BoxPleatShape: Shape {
  var pleat: CGFloat
  var gapRatio: CGFloat

  var leftFoldHeight: CGFloat {
    let overlapRatio = abs(gapRatio)
    if overlapRatio > 0.75 {
      return 0.1
    }
    return 1.0 - 0.2 - overlapRatio
  }

  var rightFoldX: CGFloat {
    if gapRatio < -1.5 {
      return pleat * 1.5
    }
    return pleat * -gapRatio
  }

  fileprivate func boxPleatPath(_ rect: CGRect) -> Path {
    var path = Path()
    path.move(to: CGPoint(x: rect.minX, y: rect.maxY))

    path.addLine(to: CGPoint(x: rect.midX - (pleat * gapRatio) / 2, y: rect.maxY))

    path.addLine(to: CGPoint(x: rect.midX - pleat / 2, y: rect.minY))
    path.addLine(to: CGPoint(x: rect.midX + pleat / 2, y: rect.minY))

    path.addLine(to: CGPoint(x: rect.midX + (pleat * gapRatio) / 2, y: rect.maxY))

    path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
    return path
  }

  fileprivate func militaryBoxPleatPath(_ rect: CGRect) -> Path {
    var path = Path()
    path.move(to: CGPoint(x: rect.minX, y: rect.midY))

    path.addLine(to: CGPoint(x: rect.midX, y: leftFoldHeight * rect.maxY))

    path.addLine(to: CGPoint(x: rect.midX - pleat / 2, y: rect.minY))
    path.addLine(to: CGPoint(x: rect.midX + pleat / 2, y: rect.minY))

    path.addLine(to: CGPoint(x: rect.midX - rightFoldX, y: rect.maxY))

    path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))

    return path
  }

  func path(in rect: CGRect) -> Path {
    if gapRatio >= 0 {
      return boxPleatPath(rect)
    }
    return militaryBoxPleatPath(rect)
  }

  var animatableData: Double {
    get { gapRatio }
    set { gapRatio = newValue }
  }
}

private func formatOptional(_ value: Double?) -> String {
  if value == nil {
    return "?"
  }
  return Value.inches(value!).formatted(.inches)
}

struct BoxPleatDrawing: View {
  var pleatPixels: CGFloat

  var gap: Gap?
  var gapRatio: CGFloat
  var gapLabel: String

  var body: some View {
    if gap == nil {
      Text("Not enough information yet")
        .padding()
    } else {
      VStack(alignment: .center) {
        DimensionLine()
          .frame(width: pleatPixels, height: 10)
          .padding([.bottom], 8)

        BoxPleatShape(pleat: pleatPixels, gapRatio: gapRatio)
          .stroke(Color.green, style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round))
          .frame(height: 50)

        if gap!.shouldDraw {
          DimensionLine()
            .frame(width: pleatPixels * abs(gapRatio), height: 10)
            .padding([.top], 8)

          Text("\(gapLabel): \(formatOptional(gap?.absoluteGap))")
        }

        Text(PleatValidator.gapMessage(gap!.size))
          .font(.headline)
          .multilineTextAlignment(.center)
      }
      .padding()
    }
  }
}

struct BoxPleatDrawing_Previews: PreviewProvider {
  static var gap = Gap(pleatWidth: .inches(2), pleatFabric: 6)

  static var previews: some View {
    ScrollView {
      Spacer()
      ForEach(-4..<2) {
        Text("\(CGFloat($0) / 2.0)")
        BoxPleatDrawing(
          pleatPixels: 150,
          gap: gap,
          gapRatio: CGFloat($0) / 2.0,
          gapLabel: "Gap"
        )
        Divider()
      }
    }
  }
}
