import SwiftUI

struct ApronPleatView: View {
  @StateObject var measures = KiltMeasures()

  @StateObject var scenarios = Scenarios()

  var body: some View {
    NavigationStack {
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
      .toolbar {
        ToolbarItem(placement: .primaryAction) {
          Button(action: {
            scenarios.append(measures)
          }) {
            Image(systemName: "plus")
          }
          .opacity(measures.allowsScenarios ? 1.0 : 0.0)
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
