import SwiftUI

struct ContentView: View {
  let keypad: Keypad

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
    ContentView(keypad: Keypad.example)
  }
}
