import SwiftUI

struct ContentView: View {
  @ObservedObject var calculator: Calculator

  var keypad: Keypad

  let columns = Array(repeating: GridItem(.flexible()), count: 5)

  init(calculator: Calculator) {
    self.calculator = calculator
    self.keypad = Keypad(calculator)
  }

  var body: some View {
    VStack {
      Text(calculator.display)
        .accessibilityLabel("display")
        .italic(calculator.alreadyEnteringNewNumber)
        .padding(4)
        .frame(width: 330, alignment: .trailing)
        .border(Color.black)

      LazyVGrid(columns: columns) {
        ForEach(keypad.contents, id: \.self) { row in
          Group { // GridRow {
            ForEach(row) { key in
              Button(key.name) {
                key.press()
              }
              .frame(width: 60, height: 60)
              .background(Color("KeyColor"))
            }
          }
        }
      }

//      Text(calculator.input)
//        .accessibilityLabel("input")
//        .padding(4)
//        .frame(width: 330, alignment: .trailing)
//        .border(Color.orange)
    }
    .font(.largeTitle)
    .padding()
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView(calculator: Calculator())
  }
}
