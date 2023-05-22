import SwiftUI

struct ContentView: View {
  @ObservedObject var calculator: Calculator

  @StateObject var keypad: Keypad

  init(calculator: Calculator) {
    self.calculator = calculator
    self._keypad = StateObject(wrappedValue: Keypad(calculator))
  }

  var body: some View {
    VStack {
      Text(calculator.display)
        .padding(4)
        .frame(width: 330, alignment: .trailing)
        .border(Color.black)
      Grid {
        ForEach(keypad.contents, id:\.self) { row in
          GridRow {
            ForEach(row) { key in
              Text(key.name)
                .frame(width: 60, height: 60)
                .background(Color("KeyColor"))
                .onTapGesture {
                  key.press()
                }
            }
          }
        }
      }
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
