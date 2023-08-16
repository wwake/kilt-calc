import Foundation

public class Scenarios: ObservableObject {
  @Published public var scenarios: [ScenarioSplit] = [ScenarioSplit([.waist: 20, .hips: 30])]
}
