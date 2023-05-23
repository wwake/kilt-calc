import SwiftUI

struct ContentView: View {
  @ObservedObject var calculator: Calculator

  @StateObject var keypad: Keypad

  let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]

  init(calculator: Calculator) {
    self.calculator = calculator
    self._keypad = StateObject(wrappedValue: Keypad(calculator))
  }

  var body: some View {
    VStack {
      Text(calculator.display)
        .accessibilityLabel("display")
        .padding(4)
        .frame(width: 330, alignment: .trailing)
        .border(Color.black)

      LazyVGrid(columns: columns) {
        ForEach(keypad.contents, id: \.self) { row in
          Group { // GridRow {
            ForEach(row) { key in
              Text(key.name)
                .accessibilityLabel(key.name)
                .frame(width: 60, height: 60)
                .background(Color("KeyColor"))
                .onTapGesture {
                  key.press()
                }
                .accessibility(addTraits: .isButton)
                .accessibility(hint: Text("\(key.name)"))
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
