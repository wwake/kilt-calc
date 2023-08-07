import SwiftUI

struct ContentView: View {
  @ObservedObject var calculator: Calculator
  @StateObject var tartan = TartanDesign()

  var body: some View {
    TabView {
      ZStack {
        Image(decorative: "Background")
          .resizable()
          .ignoresSafeArea()
        CalculatorView(calculator: calculator)
      }
      .tabItem {
        Label("Calculator", systemImage: "grid")
      }

      ZStack {
        Image(decorative: "Background")
          .resizable()
          .ignoresSafeArea()

        ApronPleatView()
      }
      .tabItem {
        Label("Apron/Pleat", systemImage: "circle.bottomhalf.filled")
      }

      PleatView(tartan: tartan)
      .tabItem {
        Label("Pleats", systemImage: "rectangle.split.3x1")
      }
    }
    .preferredColorScheme(.light)
  }
}

struct ContentView_Previews: PreviewProvider {
  var tartan = TartanDesign()

  static var previews: some View {
    ContentView(calculator: Calculator())
  }
}
