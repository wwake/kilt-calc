import SwiftUI

struct ApronPleatView: View {
  @StateObject var measures = KiltMeasures()

  @StateObject var scenarios = Scenarios()

  var body: some View {
    VStack {
      MeasurementTable(measures: measures)
        .background(.thinMaterial)
        .padding()
        .onChange(of: measures.allowsScenarios) {
          scenarios.changeScenarios($0, measures)
        }
        .onChange(of: measures.idealWaist) { _ in
          scenarios.changeScenarios(measures.allowsScenarios, measures)
        }
        .onChange(of: measures.idealHips) { _ in
          scenarios.changeScenarios(measures.allowsScenarios, measures)
        }

      if measures.allowsScenarios {
        ForEach(scenarios.scenarios, id: \.self) { scenario in
          ScenarioView(scenario: scenario)
        }
      }
    }
  }
}

struct ApronPleatView_Previews: PreviewProvider {
  static var previews: some View {
    ApronPleatView()
  }
}
