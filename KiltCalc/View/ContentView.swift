import SwiftUI

enum TopLevelTab: Int {
  case calculator
  case apronPleat
  case pleats
}

struct ContentView: View {
  @ObservedObject var calculator: Calculator
  @StateObject var tartan = TartanDesign()
  @StateObject private var designer = PleatDesigner(PleatDesigner.boxPleat)

  @AppStorage("topLevelTab")
  var topLevelTab: TopLevelTab = .calculator

  var body: some View {
    TabView(selection: $topLevelTab) {
      ZStack {
        Image(decorative: "Background")
          .resizable()
          .ignoresSafeArea()
        CalculatorView(calculator: calculator)
      }
      .tabItem {
        Label("Calculator", systemImage: "grid")
      }
      .tag(TopLevelTab.calculator)

      ZStack {
        Image(decorative: "Background")
          .resizable()
          .ignoresSafeArea()

        ApronPleatView(topLevelTab: $topLevelTab)
      }
      .tabItem {
        Label("Apron/Pleat", systemImage: "circle.bottomhalf.filled")
      }
      .tag(TopLevelTab.apronPleat)

      PleatView(tartan: tartan, designer: designer)
      .tabItem {
        Label("Pleats", systemImage: "rectangle.split.3x1")
      }
      .tag(TopLevelTab.pleats)
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
