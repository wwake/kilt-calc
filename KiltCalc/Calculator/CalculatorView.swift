import SwiftUI

struct CalculatorView: View {
  @ObservedObject var calculator: Calculator
  @State private var selectedUnitFormat: ImperialFormatter = .inches
  @State private var showHistory = false
  @State private var showError = false

  var keypad = Keypad()

  let columns = Array(repeating: GridItem(.flexible()), count: 5)

  init(calculator: Calculator) {
    self.calculator = calculator
    UITabBar.appearance().backgroundColor = UIColor(.white).withAlphaComponent(0.5)
  }

  var body: some View {
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
                .shrinking()
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
}

struct CalculatorView_Previews: PreviewProvider {
  static var previews: some View {
    CalculatorView(calculator: Calculator())
  }
}

struct ShrinkingButton: ButtonStyle {
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .frame(width: 64, height: 64)
      .background(Color("KeyColor"))
      .foregroundColor(Color("AccentColor"))
      .clipShape(RoundedRectangle(cornerRadius: 15))
      .shadow(color: .gray, radius: 2, x: 3, y: 3)
      .scaleEffect(configuration.isPressed ? 0.9 : 1)
      .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
  }
}

extension View {
  public func shrinking() -> some View {
    buttonStyle(ShrinkingButton())
  }
}
