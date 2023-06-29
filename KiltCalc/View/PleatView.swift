import SwiftUI

struct PleatView: View {
  @State private var notes: String = ""
  @State private var hipToHipMeasure: Double? = 20
  @State private var sett: Double? = 7.0
  @State private var settsPerPleat: Double? = 1.0
  @State private var pleatWidth: Double? = 2.0
  @State private var pleatCount: Double? = 2.0
  @State private var gap: Double? = 0.0

  @StateObject private var designer = PleatDesigner()

  func field(_ label: String, _ boundDouble: Binding<Double?>) -> some View {
    LabeledContent {
      TextField(label, value: boundDouble, format: .number)
        .multilineTextAlignment(.trailing)
        .keyboardType(.numberPad)
    } label: {
      Text(label)
    }
  }

  var body: some View {
    NavigationView {
      VStack {
        Form {
          LabeledContent {
            TextField("Notes", text: $designer.notes, prompt: Text("Name, tartan, or other notes"))
              .lineLimit(3)
          } label: {
            Text("Notes")
          }

          field("Hip to Hip (rear)", $designer.hipToHipMeasure)
          field("Sett", $designer.sett)
          field("Setts/Pleat", $designer.settsPerPleat)
          field("Pleat Width", $designer.pleatWidth)
          field("Gap", $designer.gap)
          field("#Pleats", $designer.pleatCount)
        }

        PleatDrawing()

        Spacer()
      }
      .navigationTitle("Pleats")
    }
  }
}

struct PleatView_Previews: PreviewProvider {
  static var previews: some View {
    PleatView()
  }
}
