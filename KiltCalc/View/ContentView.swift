import SwiftUI

struct ContentView: View {
  @ObservedObject var calculator: Calculator
  @State private var selectedUnitFormat: ImperialFormatter = .inches

  let disabledKeys = Set(["MC", "MR", "M+", "M-", "%", "/", Keypad.dot])

  var keypad = Keypad()

  let columns = Array(repeating: GridItem(.flexible()), count: 5)

  var body: some View {
    ZStack {
      Image(decorative: "Background")
        .resizable()
        .ignoresSafeArea()

      VStack {
        Text("\(calculator.previous.0) = \(calculator.previous.1)")
          .accessibilityIdentifier("previous")
          .accessibilityLabel("previous")
          .font(.footnote)
          .padding(4)
          .frame(width: 330, alignment: .trailing)
          .background(Color.white)
          .border(Color.black)

        Text(calculator.display)
          .accessibilityIdentifier("display")
          .accessibilityLabel("display")
          .padding(4)
          .frame(width: 330, alignment: .trailing)
          .background(Color.white)
          .border(Color.black)

        HStack {
          Picker("Unit Format", selection: $selectedUnitFormat) {
            ForEach(ImperialFormatter.allCases) {
              Text($0.rawValue)
            }
          }
          .onChange(of: selectedUnitFormat) {
            calculator.imperialFormat = $0
          }
          .accessibilityIdentifier("unitFormat")
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
                .background(Color("KeyColor"))
                .border(Color("AccentColor"), width: 1)
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
