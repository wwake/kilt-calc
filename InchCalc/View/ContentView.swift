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

      Grid {
        ForEach(keypad.contents, id:\.self) { row in
          GridRow {
            ForEach(row) {
              Text($0.name)
            }
          }
        }
      }
    }
    .padding()
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView(keypad: KeyPad(contents:
      [
        [Key("C"), Key("("), Key(")"), Key("\u{232B}")],
        [Key("yd"), Key("ft"), Key("in")]
      ]))
  }
}
