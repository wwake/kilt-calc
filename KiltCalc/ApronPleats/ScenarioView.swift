import SwiftUI

struct ScenarioView: View {
  var scenario: ScenarioSplit

  var body: some View {
    Text("ScenarioView: waist apron= \(scenario[.waist]?.apron ?? 0)")
  }
}

struct ScenarioView_Previews: PreviewProvider {
  static var previews: some View {
    ScenarioView(scenario: ScenarioSplit([.waist: 22.0, .hips: 30.0]))
  }
}
