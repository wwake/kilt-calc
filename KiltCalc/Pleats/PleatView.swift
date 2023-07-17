import Combine
import SwiftUI

struct PleatView: View {
  @StateObject private var designer = PleatDesigner()

  // see https://stackoverflow.com/questions/56491386/how-to-hide-keyboard-when-using-swiftui
  enum PleatField: Int, CaseIterable, Equatable {
    case title, hip2, hipToHip, sett, settsPerPleat, numberOfPleats, pleatWidth
  }

  @FocusState private var focusedField: PleatField?

  func field(_ label: String, focus: PleatField, _ boundValue: Binding<Value?>, _ message: String) -> some View {
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

  func field2() -> some View {
    ValidatingTextField(label: "Hip2", bound: $designer.hipToHipMeasure)
    //    VStack {
    //      LabeledContent {
    //        TextField("Hip2", text: $designer.hipString)
    //          .multilineTextAlignment(.trailing)
    //          .keyboardType(.decimalPad)
    //          .focused($focusedField, equals: .hip2)
    //          .onChange(of: focusedField) { isFocused in
    //            if designer.hipString.isEmpty { return }
    //            if isFocused != .hip2 {
    //              print("focus moved")
    //              do {
    //                print("hip2 = \(designer.hipString)")
    //                designer.hipString = try Value.parse(designer.hipString).formatted(.inches)
    //              } catch {
    //                print("can't happen")
    //              }
    //            }
    //          }
    //      } label: {
    //        Text("Hip2")
    //          .bold()
    //      }
    //      .padding(designer.hipError.isEmpty ? 0 : 8)
    //      .border(Color.red, width: designer.hipError.isEmpty ? 0 : 1)
    //
    //      if !designer.hipError.isEmpty {
    //        Text(designer.hipError)
    //          .font(.footnote)
    //          .foregroundColor(Color.red)
    //      }
    //    }
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
              field2()
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
