import Combine
import SwiftUI

// see https://stackoverflow.com/questions/56491386/how-to-hide-keyboard-when-using-swiftui
enum PleatViewFocus: Int, CaseIterable, Equatable {
  case title, hipToHip, sett, settsPerPleat, numberOfPleats, pleatWidth
}

struct AdjustedHipStyle: ViewModifier {
  let adjustedHip: Value?
  let hipWasAdjusted: Bool

  init(_ adjustedHip: Value?, _ hipWasAdjusted: Bool) {
    self.adjustedHip = adjustedHip
    self.hipWasAdjusted = hipWasAdjusted
  }

  func body(content: Content) -> some View {
    var color = Color.black

    if adjustedHip == nil {
      color = Color.gray
    } else if hipWasAdjusted {
      color = Color.red
    }

    return content
      .bold(hipWasAdjusted)
      .foregroundColor(color)
  }
}

extension View {
  func adjustedHipStyle(_ adjustedHip: Value?, _ hipWasAdjusted: Bool) -> some View {
    modifier(AdjustedHipStyle(adjustedHip, hipWasAdjusted))
  }
}

struct PleatView: View {
  @StateObject private var designer = PleatDesigner()
  @State private var slashIsPressed = false

  @FocusState private var focusedField: PleatViewFocus?

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
            Section("Required") {
              ValidatingTextField(
                label: "Ideal Hip (in)",
                bound: $designer.idealHip,
                validator: PleatValidator.positive,
                slashIsPressed: $slashIsPressed
              )
              .focused($focusedField, equals: .hipToHip)

              ValidatingTextField(
                label: "Sett",
                bound: $designer.sett,
                validator: PleatValidator.positive,
                slashIsPressed: $slashIsPressed
              )
              .focused($focusedField, equals: .sett)

              ValidatingTextField(
                label: "Setts/Pleat",
                bound: $designer.settsPerPleat,
                validator: PleatValidator.positive,
                slashIsPressed: $slashIsPressed
              )
              .focused($focusedField, equals: .settsPerPleat)
            }

            Section("Adjustable") {
              ValidatingTextField(
                label: "#Pleats",
                bound: $designer.pleatCount,
                validator: PleatValidator.positive,
                slashIsPressed: $slashIsPressed,
                disabled: designer.needsRequiredValues
              )
              .focused($focusedField, equals: .numberOfPleats)

              ValidatingTextField(
                label: "Pleat Width",
                bound: $designer.pleatWidth,
                validator: PleatValidator.positiveSmaller(designer.pleatFabric),
                slashIsPressed: $slashIsPressed,
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

              LabeledContent {
                Text(formatOptional(designer.adjustedHip))
              } label: {
                Text("Adjusted Hip Size (in)")
              }
              .adjustedHipStyle(designer.adjustedHip, designer.hipWasAdjusted)
            }
            .foregroundColor(designer.needsRequiredValues ? Color.gray : Color.black)
          }
          .frame(height: 650)
          .toolbar {
            ToolbarItem(placement: .keyboard) {
              HStack {
                Button("Done") {
                  focusedField = nil
                }
                Spacer()
                Button(action: { slashIsPressed = true }) {
                  HStack {
                    Spacer()
                    Text("/")
                      .bold()
                    Spacer()
                  }
                  .padding(2)
                  .background(Color.white)
                  .frame(width: 100)
                }
              }
            }
          }

          Text(designer.pleatType)
            .font(.headline)
            .multilineTextAlignment(.center)
            .padding(.bottom, 4)

          BoxPleatDrawing(
            pleatText: "Pleat: \( formatOptional(designer.pleatWidth))",
            pleat: 200,
            gapText: "\(designer.gapLabel): \( formatOptional(designer.gap))",
            gapRatio: designer.gapRatio
          )

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
