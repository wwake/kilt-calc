import Combine
import SwiftUI

// see https://stackoverflow.com/questions/56491386/how-to-hide-keyboard-when-using-swiftui
enum PleatViewFocus: Int, CaseIterable, Equatable {
  case hipToHip, sett, settsPerPleat, numberOfPleats, pleatWidth
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

  func formatOptional(_ value: Double?) -> String {
    if value == nil {
      return "?"
    }
    return value!.formatted()
  }

  func formatOptional(_ value: Value?) -> String {
    if value == nil {
      return "?"
    }
    return "\(value!.formatted(.inches))"
  }
  @State private var stepsInPleat: Double = 1.0

  var body: some View {
    NavigationView {
      List {
        Section("Tartan") {
          VStack {
            ValidatingTextField(
              label: "Sett",
              bound: $designer.sett,
              validator: PleatValidator.positive,
              slashIsPressed: $slashIsPressed
            )
            .focused($focusedField, equals: .sett)

            TartanDrawing()

            Slider(value: $stepsInPleat, in: 0...2, step: 0.25)
              .onChange(
                of: stepsInPleat,
                perform: { _ in
                  if stepsInPleat < 0.5 {
                    stepsInPleat = 0.5
                  }
                }
              )
              .padding([.leading, .trailing], 44)

            ValidatingTextField(
              label: "Setts/Pleat",
              bound: $designer.settsPerPleat,
              validator: PleatValidator.positive,
              slashIsPressed: $slashIsPressed
            )
            .focused($focusedField, equals: .settsPerPleat)
          }

          Text("\(stepsInPleat)")
        }

        Section("Pleats") {
          VStack {
            ValidatingTextField(
              label: "Ideal Hip (in)",
              bound: $designer.idealHip,
              validator: PleatValidator.positive,
              slashIsPressed: $slashIsPressed
            )
            .focused($focusedField, equals: .hipToHip)

            PleatCountDrawing(count: designer.pleatCount)

            HStack {
              Stepper("#Pleats", value: $designer.pleatCount, in: 3...30)
              Text("\(designer.pleatCount)")
            }
            .disabled(designer.needsRequiredValues)
          }
        }
        .foregroundColor(designer.needsRequiredValues ? Color.gray : Color.black)

        Section("Pleat Shape") {
          VStack {
            ValidatingTextField(
              label: "Pleat Width",
              bound: $designer.pleatWidth,
              validator: PleatValidator.positiveSmaller(designer.pleatFabric),
              slashIsPressed: $slashIsPressed,
              disabled: designer.needsRequiredValues
            )
            .focused($focusedField, equals: .pleatWidth)
            .foregroundColor(designer.needsRequiredValues ? Color.gray : Color.black)

            BoxPleatDrawing(
              pleatPixels: 200,
              gapText: "Gap: \( formatOptional(designer.gap)) in",
              gapRatio: designer.gapRatio
            )

            Text(PleatValidator.gapMessage(designer.gap))
              .font(.headline)
              .multilineTextAlignment(.center)
          }
        }

        Section {
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
      .navigationTitle("Pleats")
    }
  }
}

struct PleatView_Previews: PreviewProvider {
  static var previews: some View {
    PleatView()
  }
}
