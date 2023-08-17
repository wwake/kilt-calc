import SwiftUI

struct ScenarioView: View {
  var scenario: ScenarioSplit

  var body: some View {
    VStack {
      Grid {
        GridRow {
          Text("")

          Text("Apron")
            .bold()

          Text("Pleats")
            .bold()
        }
        Divider()

        GridRow {
          Text("Waist")
            .bold()

          Text("\(scenario[.waist]!.apron.formatQuarter())")

          Text("\(scenario[.waist]!.pleat.formatQuarter())")
        }

        Divider()

        GridRow {
          Text("Hips")
            .bold()

          Text("\(scenario[.hips]!.apron.formatQuarter())")

          Text("\(scenario[.hips]!.pleat.formatQuarter())")
        }
      }
      .padding()
      .border(Color.black, width: 2)
    }
  }
}

struct ScenarioView_Previews: PreviewProvider {
  static var previews: some View {
    ScenarioView(scenario: ScenarioSplit([.waist: 22.0, .hips: 30.0]))
  }
}
