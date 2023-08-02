import Combine
import Foundation
import SwiftUI

enum PleatViewFocus: Int, CaseIterable, Equatable {
  case idealHip, sett, pleatWidth
}

public class TartanDesign: ObservableObject {
  @Published public var sett: Value?

  @Published public var settsPerPleat: Double = 1.0

  public var pleatFabric: Double? {
    if sett == nil { return nil }
    return sett!.asDouble * settsPerPleat
  }
}

struct PleatView: View {
  @StateObject private var tartan = TartanDesign()
  @StateObject private var designer = BoxPleatDesigner()

  @State private var slashIsPressed = false

  @FocusState private var focusedField: PleatViewFocus?

  func formatOptional(_ value: Double?) -> String {
    if value == nil {
      return "?"
    }
    return Value.inches(value!).formatted(.inches)
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
    NavigationView {
      List {
        Section("Tartan") {
          VStack {
            ValidatingTextField(
              label: "Sett",
              value: $tartan.sett,
              validator: PleatValidator.positive,
              slashIsPressed: $slashIsPressed
            )
            .focused($focusedField, equals: .sett)
            .padding([.trailing], 116)
            .onChange(of: tartan.sett) { _ in
              designer.pleatFabric = tartan.pleatFabric
            }

            TartanDrawing(highlight: designer.settsPerPleat)

            Slider(value: $designer.settsPerPleat, in: 0...2, step: 0.25, onEditingChanged: {_ in
                  focusedField = nil
                })
              .padding([.leading, .trailing], 44)
              .onChange(of: tartan.settsPerPleat) { _ in
                designer.pleatFabric = tartan.pleatFabric
              }

            Text("Setts in One Pleat: \(formatFraction(designer.settsPerPleat))")
          }
        }

        Section("Pleats") {
          VStack {
            HStack {
              Spacer()

              ValidatingTextField(
                label: "Ideal Hip",
                value: $designer.idealHip,
                validator: PleatValidator.positive,
                slashIsPressed: $slashIsPressed
              )
              .focused($focusedField, equals: .idealHip)

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
                Stepper(
                  "#Pleats:   \(designer.pleatCount)",
                  value: $designer.pleatCount,
                  in: 3...30,
                  onEditingChanged: {_ in
                      focusedField = nil
                  }
                )
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
              value: $designer.pleatWidth,
              validator: PleatValidator.positiveSmaller(designer.pleatFabric),
              slashIsPressed: $slashIsPressed,
              disabled: designer.needsRequiredValues
            )
            .focused($focusedField, equals: .pleatWidth)
            .foregroundColor(designer.needsRequiredValues ? Color.gray : Color.black)

            BoxPleatDrawing(
              pleatPixels: 200,
              gapRatio: designer.gapRatio,
              drawGap:
                !PleatValidator.isMilitaryBoxPleat(designer.gap),
              gapLabel: designer.gapLabel,
              gapText: "\( formatOptional(designer.absoluteGap))"
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
            Text("Total Fabric for Pleats")
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
      .navigationTitle("Pleats")
    }
  }
}

struct PleatView_Previews: PreviewProvider {
  static var previews: some View {
    PleatView()
  }
}
