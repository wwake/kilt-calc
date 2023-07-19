import Combine
import SwiftUI

// see https://stackoverflow.com/questions/56491386/how-to-hide-keyboard-when-using-swiftui
enum PleatViewFocus: Int, CaseIterable, Equatable {
  case title, hipToHip, sett, settsPerPleat, numberOfPleats, pleatWidth
}

struct PleatView: View {
  @StateObject private var designer = PleatDesigner()

  @FocusState private var focusedField: PleatViewFocus? {
    didSet {
      print("Focus changed - \(String(describing: oldValue)) -> \(String(describing: focusedField))")
    }
  }

  func field(_ label: String, focus: PleatViewFocus, _ boundValue: Binding<Value?>, _ message: String) -> some View {
    VStack {
      LabeledContent {
        TextField(label, value: boundValue, format: .inches)
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

  func formatOptional(_ value: Value?) -> String {
    if value == nil {
      return "?"
    }
    return "\(value!.formatted(.inches))"
  }

  var body: some View {
    NavigationView {
      ScrollView(.vertical) {
        VStack {
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
              ValidatingTextField(
                label: "Hip to Hip (rear)",
                bound: $designer.hipToHipMeasure,
                validator: PleatValidator.positive
              )
              .focused($focusedField, equals: .hipToHip)

              ValidatingTextField(
                label: "Sett",
                bound: $designer.sett,
                validator: PleatValidator.positive
              )
              .focused($focusedField, equals: .sett)

              ValidatingTextField(
                label: "Setts/Pleat",
                bound: $designer.settsPerPleat,
                validator: PleatValidator.positive
              )
              .focused($focusedField, equals: .settsPerPleat)
            }

            Section("Adjustable") {
              ValidatingTextField(
                label: "#Pleats",
                bound: $designer.pleatCount,
                validator: PleatValidator.positive,
                disabled: designer.needsRequiredValues
              )
              .focused($focusedField, equals: .numberOfPleats)

              ValidatingTextField(
                label: "Pleat Width",
                bound: $designer.pleatWidth,
                validator: PleatValidator.positiveSmaller(designer.pleatFabric),
                disabled: designer.needsRequiredValues
              )
              .focused($focusedField, equals: .pleatWidth)
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

          Text(designer.pleatType)
            .font(.headline)
            .multilineTextAlignment(.center)
            .padding(.bottom, 4)

          BoxPleatDrawing(pleat: 200, gap: 40)

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
