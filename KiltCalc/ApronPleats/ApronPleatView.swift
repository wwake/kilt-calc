import SwiftUI

struct ApronPleatView: View {
  @StateObject var measures = KiltMeasures()

  @StateObject var scenarios = Scenarios()

  var body: some View {
    NavigationStack {
      ScrollView {
        VStack {
          Text("Measurements")
            .font(.title2)
          
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
            Divider()
            
            Text("Splits")
              .font(.title2)
            
            ForEach($scenarios.scenarios) { scenario in
              ScenarioView(scenario: scenario)
                .background(.thinMaterial)
                .padding()
            }
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
      .navigationTitle("Apron/Pleat Splits")
    }
  }
}

struct ApronPleatView_Previews: PreviewProvider {
  static var previews: some View {
    ApronPleatView()
  }
}
