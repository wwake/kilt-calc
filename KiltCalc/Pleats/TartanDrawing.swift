import SwiftUI

struct TartanDrawing: View {
  var highlight: Double

  let stripes: [(Color, Int)] = [
    (.red, 6), (.orange, 2), (.black, 6), (.yellow, 2),
    (.red, 4), (.orange, 2), (.black, 6), (.yellow, 2),
    (.red, 4), (.orange, 2), (.black, 6), (.yellow, 2),
    (.red, 6),
  ]

  var body: some View {
    GeometryReader { proxy in
      VStack {
        DimensionLine()
          .frame(width: proxy.size.width / 3.0)
          .offset(CGSize(width: -proxy.size.width / 6.0, height: 0))

        Spacer()
          .frame(height: 16)

        ZStack {
          HStack(spacing: 0) {
            Color("AccentColor")
              .opacity(0.5)
              .frame(width: (2.0 / 12.0) * proxy.size.width)
            Color("AccentColor")
              .frame(width: (highlight * 4.0 / 12.0) * proxy.size.width)
            Color("AccentColor")
              .opacity(0.5)
          }

          ForEach(0..<stripes.count, id: \.self) { index in
            VerticalLine(Double(index) / 12.0)
              .stroke(stripes[index].0, lineWidth: CGFloat(stripes[index].1))
          }
        }
      }
    }
    .frame(height: 75)
  }
}

struct TartanDrawing_Previews: PreviewProvider {
  static var previews: some View {
    TartanDrawing(highlight: 0.5)
    TartanDrawing(highlight: 1)
    TartanDrawing(highlight: 2)
  }
}
