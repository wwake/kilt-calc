import SwiftUI

struct ApronPleatView: View {
  @StateObject var measures = KiltMeasures()

  @StateObject var scenarios = Scenarios()

  var body: some View {
    VStack {
      MeasurementTable(measures: measures)
        .padding()

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
