import SwiftUI

enum TopLevelTab: Int {
  case calculator
  case apronPleat
  case pleats
}

public struct ContentView: View {
  @ObservedObject var calculator: Calculator
  @ObservedObject var designer: PleatDesigner

  @StateObject var tartan = TartanDesign()

  @State var showCaution = true

  @AppStorage("topLevelTab")
  var topLevelTab: TopLevelTab = .calculator

  public var body: some View {
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

      ApronPleatView(topLevelTab: $topLevelTab, designer: designer)
      .tabItem {
        Label("Apron/Pleat", systemImage: "circle.bottomhalf.filled")
      }
      .tag(TopLevelTab.apronPleat)

      ZStack {
        Image(decorative: "Background")
          .resizable()
          .ignoresSafeArea()
        PleatView(tartan: tartan, designer: designer)
      }
      .tabItem {
        Label("Pleats", systemImage: "rectangle.split.3x1")
      }
      .tag(TopLevelTab.pleats)
    }
    .sheet(isPresented: $showCaution) {
      CautionView()
    }
    .preferredColorScheme(.light)
  }
}

struct ContentView_Previews: PreviewProvider {
  var tartan = TartanDesign()
  @StateObject static var designer = PleatDesigner(PleatDesigner.boxPleat)

  static var previews: some View {
    ContentView(calculator: Calculator(), designer: designer)
  }
}
