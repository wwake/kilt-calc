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
        .bold()
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
      ScrollView(.vertical) {
        VStack {
          Form {
            LabeledContent {
              TextField("Notes", text: $designer.notes, prompt: Text("Name, tartan, or other notes"))
                .lineLimit(3)
            } label: {
              Text("Notes")
                .bold()
            }

            Section("Required") {
              field("Hip to Hip (rear)", $designer.hipToHipMeasure)
              field("Sett", $designer.sett)
              field("Setts/Pleat", $designer.settsPerPleat)
            }

            Section("Adjustable") {
              field("#Pleats", $designer.pleatCount)
                .foregroundColor(designer.needsRequiredValues ? Color.gray : Color.black)
                .disabled(designer.needsRequiredValues)

              field("Pleat Width", $designer.pleatWidth)
                .foregroundColor(designer.needsRequiredValues ? Color.gray : Color.black)
                .disabled(designer.needsRequiredValues)
            }

            Section {
              LabeledContent {
                Text(formatOptional(designer.gap))
              } label: {
                Text("Gap")
              }

              LabeledContent {
                Text(formatOptional(designer.totalFabric))
              } label: {
                Text("Total Fabric for Pleats (in)")
              }
            }
            .foregroundColor(designer.needsRequiredValues ? Color.gray : Color.black)
          }
          .frame(height: 550)

          PleatDrawing()

          Spacer()
          Spacer()
        }
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
