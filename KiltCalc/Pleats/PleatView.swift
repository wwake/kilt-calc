import Combine
import Foundation
import SwiftUI

enum PleatViewFocus: Int, CaseIterable, Equatable {
  case idealHip, sett, pleatWidth
}

struct PleatView: View {
  @StateObject private var tartan = TartanDesign()

  @StateObject private var boxPleatDesigner = PleatDesigner(PleatDesigner.boxPleat)
  @StateObject private var knifePleatDesigner = PleatDesigner(PleatDesigner.knifePleat)

  @State private var slashIsPressed = false

  @FocusState private var focusedField: PleatViewFocus?

  func formatOptional(_ value: Double?) -> String {
    if value == nil {
      return "?"
    }
    return Value.inches(value!).formatted(.inches)
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

  var tartanView: some View {
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
//          boxPleatDesigner.pleatFabric = tartan.pleatFabric
//          knifePleatDesigner.pleatFabric = tartan.pleatFabric
        }

        TartanDrawing(highlight: tartan.settsPerPleat)

        Slider(value: $tartan.settsPerPleat, in: 0...2, step: 0.25, onEditingChanged: {_ in
          focusedField = nil
        })
        .padding([.leading, .trailing], 44)
        .onChange(of: tartan.settsPerPleat) { _ in
//          boxPleatDesigner.pleatFabric = tartan.pleatFabric
//          knifePleatDesigner.pleatFabric = tartan.pleatFabric
        }

        Text("Setts in One Pleat: \(formatFraction(tartan.settsPerPleat))")
      }
  }

  var boxPleat: some View {
    VStack {
      ValidatingTextField(
        label: "Width",
        value: $boxPleatDesigner.pleatWidth,
        validator: PleatValidator.positiveSmaller(boxPleatDesigner.pleatFabric),
        slashIsPressed: $slashIsPressed,
        disabled: boxPleatDesigner.needsRequiredValues
      )
      .focused($focusedField, equals: .pleatWidth)
      .foregroundColor(boxPleatDesigner.needsRequiredValues ? Color.gray : Color.black)

      BoxPleatDrawing(
        pleatPixels: 200,
        gapRatio: boxPleatDesigner.gapRatio,
        drawGap:
          !PleatValidator.isMilitaryBoxPleat(boxPleatDesigner.gap),
        gapLabel: boxPleatDesigner.gapLabel,
        gapText: "\( formatOptional(boxPleatDesigner.absoluteGap))"
      )

      Text(PleatValidator.gapMessage(boxPleatDesigner.gap))
        .font(.headline)
        .multilineTextAlignment(.center)
    }
  }

  var knifePleat: some View {
    VStack {
      ValidatingTextField(
        label: "Width",
        value: $knifePleatDesigner.pleatWidth,
        validator: PleatValidator.positiveSmaller(knifePleatDesigner.pleatFabric),
        slashIsPressed: $slashIsPressed,
        disabled: knifePleatDesigner.needsRequiredValues
      )
      .focused($focusedField, equals: .pleatWidth)
      .foregroundColor(knifePleatDesigner.needsRequiredValues ? Color.gray : Color.black)

      KnifePleatDrawing(
        pleatPixels: 200
      )
    }
  }

  enum PleatStyle: String, CaseIterable, Identifiable {
    case box = "Box / Military", knife = "Knife"
    var id: Self { self }
  }

  @State private var selectedPleat: PleatStyle = .box

  var body: some View {
    NavigationView {
      List {
        Section("Tartan") {
          tartanView
        }

        Section("Pleats") {
          switch selectedPleat {
          case .box:
            PleatCountView(
              designer: boxPleatDesigner,
              slashIsPressed: $slashIsPressed,
              focusedField: $focusedField
            )
            .onChange(of: boxPleatDesigner.idealHip) { value in
              knifePleatDesigner.idealHip = value
            }

          case .knife:
            PleatCountView(
              designer: knifePleatDesigner,
              slashIsPressed: $slashIsPressed,
              focusedField: $focusedField
            )
            .onChange(of: knifePleatDesigner.idealHip) { value in
              boxPleatDesigner.idealHip = value
            }
          }
        }

        Picker("Pleat Type", selection: $selectedPleat) {
          ForEach(PleatStyle.allCases) { style in
            Text(style.rawValue)
          }
        }
        .pickerStyle(.segmented)

        Section("Pleat Shape") {
          switch selectedPleat {
          case .box:
            boxPleat

          case .knife:
            knifePleat
          }
        }

        switch selectedPleat {
        case .box:
          Section {
            LabeledContent {
              Text(formatOptional(boxPleatDesigner.totalFabric))
            } label: {
              Text("Total Fabric for Pleats")
            }
          }
          .foregroundColor(boxPleatDesigner.needsRequiredValues ? Color.gray : Color.black)

        case .knife:
          Section {
            LabeledContent {
              Text(formatOptional(knifePleatDesigner.totalFabric))
            } label: {
              Text("Total Fabric for Pleats")
            }
          }
          .foregroundColor(knifePleatDesigner.needsRequiredValues ? Color.gray : Color.black)
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
    .onAppear {
      boxPleatDesigner.tartan = tartan
      knifePleatDesigner.tartan = tartan
    }
  }
}

struct PleatView_Previews: PreviewProvider {
  static var previews: some View {
    PleatView()
  }
}
