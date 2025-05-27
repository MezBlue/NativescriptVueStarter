import SwiftUI

@objc(SampleViewProvider)
class SampleViewProvider: UIViewController, SwiftUIProvider {
  private var swiftUIData = ButtonProps()
  private var swiftUI: SampleView?
  // MARK: INIT
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  required public init() {
    super.init(nibName: nil, bundle: nil)
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    registerObservers()
  }
  
  private func registerObservers() {
    swiftUIData.incrementCount = {
      self.swiftUIData.count = self.swiftUIData.count + 1
      // update SwiftUI view
      self.swiftUI?.props = self.swiftUIData
      // notify NativeScript
      self.onEvent?(["count": self.swiftUIData.count])
    }
  }
  
  // MARK: API
  
  /// Receive data from NativeScript
  func updateData(data: NSDictionary) {
    let enumerator = data.keyEnumerator()
    while let k = enumerator.nextObject() {
        let key = k as! String
        let v = data.object(forKey: key)
        if (v != nil) {
          if (key == "count") {
              swiftUIData.count = v as! Int
          }
        }
    }

    if (self.swiftUI == nil) {
      self.swiftUI = SampleView(props: swiftUIData)
      setupSwiftUIView(content: self.swiftUI)
      registerObservers()
    } else {
      // engage data binding right away
      self.swiftUI?.props = swiftUIData
    }
  }
  
  /// Send data to NativeScript
  var onEvent: ((NSDictionary) -> Void)?
}
