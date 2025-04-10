import SwiftUI

@objc
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
  }

  // MARK: PRIVATE

  private var swiftUIView = SampleView()

  /// Receive data from NativeScript
  func updateData(data: NSDictionary) {
      // can be empty
  }

  /// Allow sending of data to NativeScript
  var onEvent: ((NSDictionary) -> ())?
}