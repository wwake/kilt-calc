import SwiftUI

struct ContentView: View {
  @ObservedObject var calculator: Calculator
  @State private var selectedUnitFormat: ImperialFormatter = .inches
  internal var didAppear: ((Self) -> Void)? // for ViewInspector

  var keypad = Keypad()

  let columns = Array(repeating: GridItem(.flexible()), count: 5)

  var body: some View {
    VStack {
      Text(calculator.display)
        .accessibilityLabel("display")
        .padding(4)
        .frame(width: 330, alignment: .trailing)
        .border(Color.black)

        Picker("Unit Format", selection: $selectedUnitFormat) {
          ForEach(ImperialFormatter.allCases) {
            Text($0.rawValue)
          }
        }
        .pickerStyle(.menu)

      LazyVGrid(columns: columns) {
        ForEach(keypad.contents, id: \.self) { row in
          Group { // GridRow {
            ForEach(row) { key in
              Button(key.name) {
               calculator.enter(key.entry)
              }
              .frame(width: 60, height: 60)
              .background(Color("KeyColor"))
            }
          }
        }
      }
    }
    .onAppear { self.didAppear?(self) } // for ViewInspector
    .font(.largeTitle)
    .padding()
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView(calculator: Calculator())
  }
}
