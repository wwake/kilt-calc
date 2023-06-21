import SwiftUI

public struct HistoryView: View {
  @Environment(\.dismiss) var dismiss

  @ObservedObject var calculator: Calculator

  public var body: some View {
    VStack {
      Text("History")
        .font(.title)
        .padding()

      List {
        ForEach(calculator.history) {
          Text("\($0.expression) = \($0.value)")
        }
        .onDelete {
          calculator.deleteHistory(at: $0)
        }
      }
      Spacer()

      HStack {
        Button(role: .destructive) {
          calculator.clearAllHistory()
        } label: {
          Text("Clear")
        }
        .padding(8)
        .buttonFormat()

        Button("Done") {
          dismiss()
        }
        .padding(8)
        .buttonFormat()
      }
      .font(.title)
      .padding()
    }
  }
}

struct HistoryView_Previews: PreviewProvider {
  static var previews: some View {
    HistoryView(calculator: Calculator())
  }
}
