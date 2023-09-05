import Combine
import Foundation
import SwiftUI

public struct PleatView: View {
  @ObservedObject public var tartan = TartanDesign()

  @StateObject private var designer: PleatDesigner

  @State private var slashIsPressed = false

  @FocusState private var focusedField: FocusedField?

  init(tartan: TartanDesign) {
    _designer = StateObject(wrappedValue: PleatDesigner(PleatDesigner.boxPleat))
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
            if designer.gap == nil {
              Text("No enough information yet")
                .padding()
            } else {
              BoxPleatDrawing(gap: designer.gap!)
            }

          case .knife:
            if designer.depth == nil {
              Text("No enough information yet")
                .padding()
            } else {
              KnifePleatDrawing(depth: designer.depth!)
            }
          }
        }

        Section {
          LabeledContent {
            Text(designer.totalFabric)
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
  static var tartan = TartanDesign()

  static var previews: some View {
    PleatView(tartan: tartan)
  }
}
