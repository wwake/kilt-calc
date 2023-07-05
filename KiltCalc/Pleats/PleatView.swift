import SwiftUI

struct PleatView: View {
  @StateObject private var designer = PleatDesigner()

  func field(_ label: String, _ boundDouble: Binding<Double?>, _ message: String) -> some View {
    VStack {
      LabeledContent {
        TextField(label, value: boundDouble, format: .number)
          .multilineTextAlignment(.trailing)
          .keyboardType(.decimalPad)
      } label: {
        Text(label)
          .bold()
      }
      .padding(message.isEmpty ? 0 : 8)
      .border(Color.red, width: message.isEmpty ? 0 : 1)

      if !message.isEmpty {
        Text(message)
          .font(.footnote)
          .foregroundColor(Color.red)
      }
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
              TextField("Title", text: $designer.notes, prompt: Text("Name, tartan, or other notes"))
                .lineLimit(3)
            } label: {
              Text("Title")
                .bold()
            }

            Section("Required") {
              field("Hip to Hip (rear)", $designer.hipToHipMeasure, designer.hipError)
              field("Sett", $designer.sett, designer.settError)
              field("Setts/Pleat", $designer.settsPerPleat, designer.settsPerPleatError)
            }

            Section("Adjustable") {
              field("#Pleats", $designer.pleatCount, designer.pleatCountError)
                .foregroundColor(designer.needsRequiredValues ? Color.gray : Color.black)
                .disabled(designer.needsRequiredValues)

              field("Pleat Width", $designer.pleatWidth, designer.pleatWidthError)
                .foregroundColor(designer.needsRequiredValues ? Color.gray : Color.black)
                .disabled(designer.needsRequiredValues)
            }

            Section {
              LabeledContent {
                Text(formatOptional(designer.absoluteGap))
              } label: {
                Text(designer.gapLabel)
              }

              LabeledContent {
                Text(formatOptional(designer.totalFabric))
              } label: {
                Text("Total Fabric for Pleats (in)")
              }
            }
            .foregroundColor(designer.needsRequiredValues ? Color.gray : Color.black)
          }
          .frame(height: 600)

          Text(designer.message)
            .font(.title)
            .multilineTextAlignment(.center)
            .padding(.bottom, 4)

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
