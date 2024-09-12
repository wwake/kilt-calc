import Combine
import Foundation
import SwiftUI

public struct PleatView: View {
  @ObservedObject public var tartan: TartanDesign

  @ObservedObject public var designer: PleatDesigner

  enum PleatStyle: String, CaseIterable, Identifiable {
    case box = "Box / Military", knife = "Knife"
    var id: Self { self }
  }

  @State private var selectedPleat: PleatStyle = .box

  func setHip(_ value: Value) {
    designer.idealHip = value
  }

  public var body: some View {
    NavigationView {
      List {
        Section("Tartan") {
          TartanView(tartan: tartan)
          .onChange(of: tartan.pleatFabric) {
            designer.pleatFabric = tartan.pleatFabric
          }
        }

        Section("Pleats") {
          PleatCountView(designer: designer)
        }

        Picker("Pleat Type", selection: $selectedPleat) {
          ForEach(PleatStyle.allCases) { style in
            Text(style.rawValue)
          }
        }
        .pickerStyle(.segmented)
        .onChange(of: selectedPleat) {
          let initialWidth = selectedPleat == .box ? PleatDesigner.boxPleat : PleatDesigner.knifePleat
          designer.initialWidth = initialWidth(designer)
        }

        Section("Pleat Shape") {
          ValidatingTextField(
            label: "Width",
            value: $designer.pleatWidth,
            validator: PleatValidator.positiveSmaller(designer.pleatFabric),
            disabled: designer.needsRequiredValues
          )
          .foregroundColor(designer.needsRequiredValues ? Color.gray : Color.black)

          switch selectedPleat {
          case .box:
            if designer.gap == nil {
              Text("Not enough information yet")
                .padding()
            } else {
              BoxPleatDrawing(gap: designer.gap!)
            }

          case .knife:
            if designer.depth == nil {
              Text("Not enough information yet")
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
      .scrollContentBackground(.hidden)
      .background(
        Image(decorative: "Background")
        .resizable()
        .ignoresSafeArea()
      )
      .navigationTitle("Pleats")
    }
  }
}

struct PleatView_Previews: PreviewProvider {
  static var tartan = TartanDesign()
  static var designer = PleatDesigner(PleatDesigner.boxPleat)

  static var previews: some View {
    PleatView(tartan: tartan, designer: designer)
  }
}
