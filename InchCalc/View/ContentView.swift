import SwiftUI

struct Key: Identifiable, Hashable {
  let id = UUID()
  let name: String

  init(_ name: String) {
    self.name = name
  }
}

struct KeyPad {
  let contents: [[Key]]
}

struct ContentView: View {
  let keypad: KeyPad

  var body: some View {
    VStack {
      Text("0")
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
    ContentView(keypad: KeyPad(contents:
      [
        [Key("C"), Key("("), Key(")"), Key("\u{232B}")],
        [Key("yd"), Key("ft"), Key("in"), Key("+")]
      ]))
  }
}
