import SwiftUI

struct ContentView: View {
  @ObservedObject var calculator: Calculator

  var body: some View {
    TabView {
      CalculatorView(calculator: calculator)
        .tabItem {
          Label("Calculator", systemImage: "grid")
        }

      ApronPleatView()
        .tabItem {
          Label("Apron/Pleat", systemImage: "circle.bottomhalf.filled")
        }

      PleatView()
        .tabItem {
          Label("Pleats", systemImage: "rectangle.split.3x1")
        }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView(calculator: Calculator())
  }
}
