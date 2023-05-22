import SwiftUI

@main
struct InchCalcApp: App {
    var body: some Scene {
        WindowGroup {
          ContentView(keypad: KeyPad(contents: []))
        }
    }
}
