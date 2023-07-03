import SwiftUI

struct PleatView: View {
  @StateObject private var designer = PleatDesigner()

  func field(_ label: String, _ boundDouble: Binding<Double?>) -> some View {
    LabeledContent {
      TextField(label, value: boundDouble, format: .number)
        .multilineTextAlignment(.trailing)
        .keyboardType(.decimalPad)
    } label: {
      Text(label)
    }
  }

  func formatOptional(_ value: Double?) -> String {
    if value == nil {
      return "?"
    }
    return "\(value!)"
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
            .foregroundColor(designer.needsRequiredValues ? Color.gray : Color.black)
            .disabled(designer.needsRequiredValues)
          field("Gap", $designer.gap)
            .foregroundColor(designer.needsRequiredValues ? Color.gray : Color.black)
            .disabled(designer.needsRequiredValues)

          field("#Pleats", $designer.pleatCount)
            .foregroundColor(designer.needsRequiredValues ? Color.gray : Color.black)
            .disabled(designer.needsRequiredValues)
        }

        PleatDrawing()

        Spacer()
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
