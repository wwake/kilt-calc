import SwiftUI

struct ApronPleatView: View {
  @StateObject var scenarios = Scenarios()

  var body: some View {
    VStack {
      MeasurementTable()
        .padding()

      ForEach(scenarios.scenarios, id: \.self) { scenario in
        ScenarioView(scenario: scenario)
      }
    }
  }
}

struct ApronPleatView_Previews: PreviewProvider {
  static var previews: some View {
    ApronPleatView()
  }
}
