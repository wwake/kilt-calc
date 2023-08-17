import Foundation

public class Scenarios: ObservableObject {
  @Published public var scenarios: [ScenarioSplit] = []

  public func clear() {
    scenarios = []
  }

  public func append(_ scenario: ScenarioSplit) {
    scenarios.append(scenario)
  }

  func changeScenarios(_ newAllowsScenarios: Bool, _ measures: KiltMeasures) {
    clear()
    if newAllowsScenarios {
      append(ScenarioSplit([.waist: measures.idealWaist!, .hips: measures.idealHips!]))
    }
  }
}
