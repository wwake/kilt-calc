import Combine
import Foundation
import SwiftUI

enum PleatViewFocus: Int, CaseIterable, Equatable {
  case idealHip, sett, pleatWidth
}

public struct PleatView: View {
  @ObservedObject public var tartan = TartanDesign()

  @StateObject private var designer: PleatDesigner

  @State private var slashIsPressed = false

  @FocusState private var focusedField: PleatViewFocus?

  init(tartan: TartanDesign) {
    _designer = StateObject(wrappedValue: PleatDesigner(PleatDesigner.boxPleat))
  }

  func formatOptional(_ value: Double?) -> String {
    if value == nil {
      return "?"
    }
    return Value.inches(value!).formatted(.inches)
  }

  var boxPleat: some View {
    BoxPleatDrawing(
      pleatPixels: 200,
      gap: designer.gap,
      size: designer.gapSize,
      gapRatio: designer.gapRatio,
      drawGap:
        !PleatValidator.isMilitaryBoxPleat(designer.gapSize),
      gapLabel: designer.gapLabel,
      gapText: formatOptional(designer.absoluteGap)
    )
  }

  var knifePleat: some View {
    KnifePleatDrawing(depthText: formatOptional(designer.depth))
  }

  enum PleatStyle: String, CaseIterable, Identifiable {
    case box = "Box / Military", knife = "Knife"
    var id: Self { self }
  }

  @State private var selectedPleat: PleatStyle = .box

  public var body: some View {
    NavigationView {
      List {
        Section("Tartan") {
          TartanView(
            tartan: tartan,
            slashIsPressed: $slashIsPressed,
            focusedField: $focusedField
          )
          .onChange(of: tartan.pleatFabric) { _ in
            designer.pleatFabric = tartan.pleatFabric
          }
        }

        Section("Pleats") {
          PleatCountView(
            designer: designer,
            slashIsPressed: $slashIsPressed,
            focusedField: $focusedField
          )
        }

        Picker("Pleat Type", selection: $selectedPleat) {
          ForEach(PleatStyle.allCases) { style in
            Text(style.rawValue)
          }
        }
        .pickerStyle(.segmented)
        .onChange(of: selectedPleat) { _ in
          let initialWidth = selectedPleat == .box ? PleatDesigner.boxPleat : PleatDesigner.knifePleat
          designer.initialWidth = initialWidth(designer)
        }

        Section("Pleat Shape") {
          ValidatingTextField(
            label: "Width",
            value: $designer.pleatWidth,
            validator: PleatValidator.positiveSmaller(designer.pleatFabric),
            slashIsPressed: $slashIsPressed,
            disabled: designer.needsRequiredValues
          )
          .focused($focusedField, equals: .pleatWidth)
          .foregroundColor(designer.needsRequiredValues ? Color.gray : Color.black)

          switch selectedPleat {
          case .box:
            boxPleat

          case .knife:
            knifePleat
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

struct PleatView_Previews: PreviewProvider {
  static var tartan = TartanDesign()

  static var previews: some View {
    PleatView(tartan: tartan)
  }
}
