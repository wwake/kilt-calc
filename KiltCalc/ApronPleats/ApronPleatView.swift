import SwiftUI

struct ApronPleatView: View {
  @StateObject var measures = KiltMeasures()

  @StateObject var scenarios = Scenarios()

  func changeScenarios(_ newAllowsScenarios: Bool) {
    if newAllowsScenarios {
      scenarios.append(ScenarioSplit([.waist: measures.idealWaist!, .hips: measures.idealHips!]))
    } else {
      scenarios.clear()
    }
  }

  var body: some View {
    VStack {
      MeasurementTable(measures: measures)
        .padding()
        .onChange(of: measures.allowsScenarios) {
          changeScenarios($0)
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
