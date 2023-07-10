import SwiftUI

extension UIApplication {
  static var release: String {
    Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String? ?? "x.x"
  }
  static var build: String {
    Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String? ?? "x"
  }
  static var version: String {
    "\(release).\(build)"
  }
}

@main
struct KiltCalcApp: App {
  @StateObject var calculator = Calculator()

  var body: some Scene {
    WindowGroup {
      ContentView(calculator: calculator)
    }
  }
}
