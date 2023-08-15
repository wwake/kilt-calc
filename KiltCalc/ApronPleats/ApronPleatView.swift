import SwiftUI

struct ApronPleatView: View {
  var body: some View {
    VStack {
      MeasurementTable()
        .padding()
    }
  }
}

struct ApronPleatView_Previews: PreviewProvider {
  static var previews: some View {
    ApronPleatView()
  }
}
