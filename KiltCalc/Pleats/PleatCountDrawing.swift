import SwiftUI

struct PleatCountDrawing: View {
  var count: Int

  var body: some View {
    Grid(horizontalSpacing: 4) {
      GridRow {
        ForEach(0..<count, id: \.self) { _ in
          Color("AccentColor")
        }
      }
    }
  }
}

struct PleatCountDrawing_Previews: PreviewProvider {
  static var previews: some View {
    PleatCountDrawing(count: 5)
      .frame(height: 50)
  }
}
