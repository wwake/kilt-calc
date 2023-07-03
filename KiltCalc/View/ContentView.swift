import SwiftUI

struct ContentView: View {
  @ObservedObject var calculator: Calculator
  @State private var selectedUnitFormat: ImperialFormatter = .inches
  @State private var showHistory = false
  @State private var showError = false

  var keypad = Keypad()

  let columns = Array(repeating: GridItem(.flexible()), count: 5)

  fileprivate func CalculatorView() -> some View {
    ZStack {
      Image(decorative: "Background")
        .resizable()
        .ignoresSafeArea()

      VStack {
        ZStack {
          Text(
            calculator.history.isEmpty
            ? ""
            : calculator.history.last!.item
          )
          .font(.footnote)
          .valueFormat()

          HStack {
            Button(action: {
              showHistory = true
            }) {
              Image(systemName: "text.magnifyingglass")
                .scaleEffect(0.5)
                .padding([.leading], 20)
            }

            Spacer()
          }
        }
        .sheet(isPresented: $showHistory) {
          HistoryView(calculator: calculator)
        }

        Text(calculator.display)
          .valueFormat()

        HStack {
          Picker("Unit Format", selection: $selectedUnitFormat) {
            ForEach(ImperialFormatter.allCases) {
              Text($0.rawValue)
            }
          }
          .scaleEffect(1.25)
          .onChange(of: selectedUnitFormat) {
            calculator.imperialFormat = $0
          }
          .pickerStyle(.menu)
        }

        Grid {
          ForEach(keypad.contents, id: \.self) { row in
            GridRow {
              ForEach(row) { key in
                Button(key.name) {
                  calculator.enter(key.entry)
                  showError = !calculator.errorMessage.isEmpty
                }
                .frame(width: 60, height: 60)
                .buttonFormat()
              }
            }
          }
        }
      }
      .font(.largeTitle)
      .padding()
    }
    .alert(
      "Error",
      isPresented: $showError
    ) {
      Button("OK", role: .cancel) {
        calculator.resetError()
      }
    } message: {
      Text(calculator.errorMessage)
        .font(.title)
    }
  }

  var body: some View {
    TabView {
      CalculatorView()
        .tabItem {
          Label("Calculator", systemImage: "grid")
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
