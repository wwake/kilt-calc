import SwiftUI

public struct ButtonModifier: ViewModifier {
  public func body(content: Content) -> some View {
    content
      .background(Color("KeyColor"))
      .border(Color("AccentColor"), width: 1)
  }
}

extension View {
  public func buttonFormat() -> some View {
    modifier(ButtonModifier())
  }
}

public struct ValueModifier: ViewModifier {
  public func body(content: Content) -> some View {
    content
      .padding(4)
      .frame(width: 330, alignment: .trailing)
      .background(Color.white)
      .border(Color.black)
  }
}

extension View {
  public func valueFormat() -> some View {
    modifier(ValueModifier())
  }
}

struct ContentView: View {
  @ObservedObject var calculator: Calculator
  @State private var selectedUnitFormat: ImperialFormatter = .inches
  @State private var showHistory = false

  let disabledKeys = Set(["MC", "MR", "M+", "M-", "?"])

  var keypad = Keypad()

  let columns = Array(repeating: GridItem(.flexible()), count: 5)

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
            : "\(calculator.history.last!.expression) = \(calculator.history.last!.value)"
          )
          .font(.footnote)
          .valueFormat()

          HStack {
            Button(action: {
              showHistory = true
            }) {
              Image(systemName: "text.magnifyingglass")
                .scaleEffect(0.5)
                .padding([.leading], 2)
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
                }
                .disabled(disabledKeys.contains(key.name))
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
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView(calculator: Calculator())
  }
}
