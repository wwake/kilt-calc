import Foundation

public class Scenarios: ObservableObject {
  @Published public var scenarios: [ScenarioSplit] = []

  public func clear() {
    scenarios = []
  }

  public func append(_ measures: KiltMeasures) {
    if measures.idealWaist == nil || measures.idealHips == nil {
      return
    }

    let scenario = ScenarioSplit([.waist: measures.idealWaist!, .hips: measures.idealHips!])

    scenarios.append(scenario)
  }

  func changeScenarios(_ newAllowsScenarios: Bool, _ measures: KiltMeasures) {
    clear()
    if newAllowsScenarios {
      append(measures)
    }
  }
}
