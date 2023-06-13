import SwiftUI

@main
struct KiltCalcApp: App {
  @StateObject var calculator = Calculator()

  var body: some Scene {
    WindowGroup {
      ContentView(calculator: calculator)
    }
  }
}
