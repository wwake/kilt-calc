import SwiftUI

struct TartanDrawing: View {
  let stripes: [(Color, Int)] = [
    (.red, 4), (.yellow, 2), (.white, 8), (.yellow, 2),
    (.red, 4), (.yellow, 2), (.white, 8), (.yellow, 2),
    (.red, 4), (.yellow, 2), (.white, 8), (.yellow, 2),
    (.red, 4),
  ]

  var body: some View {
    GeometryReader { proxy in
      VStack {
        DimensionLine()
          .frame(width: proxy.size.width / 3.0)
          .offset(CGSize(width: -proxy.size.width / 6.0, height: 0))

        Spacer()
          .frame(height: 16)

        Color("AccentColor")
          .overlay(
            ForEach(0..<stripes.count, id: \.self) { index in
              VerticalLine(Double(index) / 12.0)
                .stroke(stripes[index].0, lineWidth: CGFloat(stripes[index].1))
            }
          )
      }
    }
    .frame(height: 100)
  }
}

struct TartanDrawing_Previews: PreviewProvider {
  static var previews: some View {
    TartanDrawing()
  }
}
