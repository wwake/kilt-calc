import SwiftUI

struct PleatView: View {
  @StateObject private var designer = PleatDesigner()

  // see https://stackoverflow.com/questions/56491386/how-to-hide-keyboard-when-using-swiftui
  enum PleatField: Int, CaseIterable {
    case title, hipToHip, sett, settsPerPleat, numberOfPleats, pleatWidth
  }

  @State private var title = ""
  @State private var hipToHip = ""
  @State private var sett = ""
  @State private var settsPerPleat = ""
  @State private var numberOfPleats = ""
  @State private var pleatWidth = ""

  @FocusState private var focusedField: PleatField?

  func field(_ label: String, focus: PleatField, _ boundValue: Binding<Double?>, _ message: String) -> some View {
    VStack {
      LabeledContent {
        TextField(label, value: boundValue, format: .number)
          .multilineTextAlignment(.trailing)
          .keyboardType(.decimalPad)
          .focused($focusedField, equals: focus)
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

  func field(_ label: String, focus: PleatField, _ boundValue: Binding<Int?>, _ message: String) -> some View {
    VStack {
      LabeledContent {
        TextField(label, value: boundValue, format: .number)
          .multilineTextAlignment(.trailing)
          .keyboardType(.numberPad)
          .focused($focusedField, equals: focus)
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
          TextField("Spike", value: $designer.hipToHipValue, format: .inches, prompt: Text("spike prompt"))

          Form {
            LabeledContent {
              TextField("Title", text: $designer.notes, prompt: Text("Name, tartan, or other notes"))
                .focused($focusedField, equals: .title)
                .lineLimit(3)
            } label: {
              Text("Title")
                .bold()
            }

            Section("Required") {
              field("Hip to Hip (rear)", focus: .hipToHip, $designer.hipToHipMeasure, designer.hipError)
              field("Sett", focus: .sett, $designer.sett, designer.settError)
              field("Setts/Pleat", focus: .settsPerPleat, $designer.settsPerPleat, designer.settsPerPleatError)
            }

            Section("Adjustable") {
              field("#Pleats", focus: .numberOfPleats, $designer.pleatCount, designer.pleatCountError)
                .foregroundColor(designer.needsRequiredValues ? Color.gray : Color.black)
                .disabled(designer.needsRequiredValues)

              field("Pleat Width", focus: .pleatWidth, $designer.pleatWidth, designer.pleatWidthError)
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
          .frame(height: 650)
          .toolbar {
            ToolbarItem(placement: .keyboard) {
              Button("Done") {
                focusedField = nil
              }
            }
          }

          Text(designer.message)
            .font(.title)
            .multilineTextAlignment(.center)
            .padding(.bottom, 4)

          PleatDrawing(pleat: 200, gap: 40)

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
