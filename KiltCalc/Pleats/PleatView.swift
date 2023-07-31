import Combine
import SwiftUI

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

  func formatFraction(_ value: Double) -> String {
    switch value {
    case 0.5:
      return "½"

    case 0.75:
      return "¾"

    case 1.25:
      return "1\u{2022}¼"

    case 1.5:
      return "1\u{2022}½"

    case 1.75:
      return "1\u{2022}¾"

    default:
      return value.formatted()
    }
  }

  var body: some View {
    List {
      Text("Pleats")
        .font(.title)

      Section("Tartan") {
        VStack {
          ValidatingTextField(
            label: "Sett",
            bound: $designer.sett,
            validator: PleatValidator.positive,
            slashIsPressed: $slashIsPressed
          )
          .focused($focusedField, equals: .sett)
          .padding([.trailing], 116)

          TartanDrawing()

          Slider(value: $designer.settsPerPleat, in: 0...2, step: 0.25)
            .padding([.leading, .trailing], 44)

          Text("Setts in One Pleat: \(formatFraction(designer.settsPerPleat))")
        }
      }

      Section("Pleats") {
        VStack {
          HStack {
            Spacer()

            ValidatingTextField(
              label: "Ideal Hip",
              bound: $designer.idealHip,
              validator: PleatValidator.positive,
              slashIsPressed: $slashIsPressed
            )
            .focused($focusedField, equals: .hipToHip)

            Spacer()
          }

          HStack {
            Spacer()
            Text("Adjusted Hip Size")
            Text(formatOptional(designer.adjustedHip))
            Text("in")
            Spacer()
          }
          .adjustedHipStyle(designer.adjustedHip, designer.hipWasAdjusted)

          PleatCountDrawing(count: designer.pleatCount)
            .overlay {
              Stepper("#Pleats:   \(designer.pleatCount)", value: $designer.pleatCount, in: 3...30)
                .frame(width: 200)
                .padding([.leading, .trailing], 12)
                .background(Color.white)
                .disabled(designer.needsRequiredValues)
            }
        }
      }
      .foregroundColor(designer.needsRequiredValues ? Color.gray : Color.black)

      Section("Pleat Shape") {
        VStack {
          ValidatingTextField(
            label: "Width",
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
      }
      .foregroundColor(designer.needsRequiredValues ? Color.gray : Color.black)
    }
    .toolbar {
      // see https://stackoverflow.com/questions/56491386/how-to-hide-keyboard-when-using-swiftui

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
  }
}

struct PleatView_Previews: PreviewProvider {
  static var previews: some View {
    PleatView()
  }
}
