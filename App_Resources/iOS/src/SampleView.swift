//App_Resources/iOS/src/SampleView.swift
import SwiftUI

class ButtonProps: ObservableObject {
  @Published var count: Int = 0
  var incrementCount: (() -> Void)?
}

struct SampleView: View {

  @ObservedObject var props = ButtonProps()

  var body: some View {
      VStack(alignment: .center, spacing: 0) {
          HStack(alignment:.center) {
              Text("Count \(props.count)")
                  .padding()
                  .scaledToFill()
                  .minimumScaleFactor(0.5)
          }
          HStack(alignment: .center) {
              Button(action: {
                  self.props.incrementCount?()
              }) {
                  Image(systemName: "plus.circle.fill")
                      .foregroundColor(.white)
                      .padding()
                      .background(LinearGradient(
                          gradient: Gradient(
                              colors: [Color.purple, Color.pink]), startPoint: .top, endPoint: .bottom
                      ))
                      .clipShape(Circle())
              }
          }
      }
      .padding()
      .clipShape(Circle())
  }
}
