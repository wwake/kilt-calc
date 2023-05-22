import SwiftUI

@main
struct InchCalcApp: App {
  @StateObject var calculator = Calculator()

  var body: some Scene {
    WindowGroup {
      ContentView(calculator: calculator)
    }
  }
}
