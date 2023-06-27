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
          Text($0.item)
            .font(.title3)
        }
        .onDelete {
          calculator.deleteHistory(at: $0)
        }
      }
      Spacer()

      HStack {
        Spacer()

        Button(role: .destructive) { // swiftlint:disable:this multiline_arguments
          calculator.clearAllHistory()
        } label: {
          Text("Clear")
        }
        .padding(8)
        .buttonFormat()

        Spacer()

        Button("Done") {
          dismiss()
        }
        .padding(8)
        .buttonFormat()

        Spacer()
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
