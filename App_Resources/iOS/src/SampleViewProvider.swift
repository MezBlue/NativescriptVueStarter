import SwiftUI

@objc(SampleViewProvider)
class SampleViewProvider: UIViewController, SwiftUIProvider {

  // MARK: INIT
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  required public init() {
    super.init(nibName: nil, bundle: nil)
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    setupSwiftUIView(content: swiftUIView)
    registerObservers()
  }
  
  // MARK: PRIVATE
  
  private var swiftUIView = SampleView()
  
  private func registerObservers() {
    swiftUIView.props.incrementCount = {
      let count = self.swiftUIView.props.count + 1
      // update SwiftUI view
      self.swiftUIView.props.count = count
      // notify NativeScript
      self.onEvent?(["count": count])
    }
  }
  
  // MARK: API
  
  /// Receive data from NativeScript
  func updateData(data: NSDictionary) {
    if let count = data.value(forKey: "count") as? Int {
      // update SwiftUI view
      swiftUIView.props.count = count
      // notify NativeScript
      self.onEvent?(["count": count])
    }
  }
  
  /// Send data to NativeScript
  var onEvent: ((NSDictionary) -> Void)?
}
