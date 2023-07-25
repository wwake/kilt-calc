import SwiftUI

struct PleatCountDrawing: View {
  var count: Int

  var body: some View {
    VStack {
      DimensionLine()

      Spacer()
        .frame(height: 10)

      Grid(horizontalSpacing: 4) {
        GridRow {
          ForEach(0..<count, id: \.self) { _ in
            Color("AccentColor")
          }
        }
      }
      .frame(height: 50)
    }
  }
}

struct PleatCountDrawing_Previews: PreviewProvider {
  static var previews: some View {
    PleatCountDrawing(count: 5)
  }
}
