import SwiftUI
import MapKit

@objc
class MapKitViewProvider: UIViewController, SwiftUIProvider {
    
    // MARK: INIT
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    required public init() {
        super.init(nibName: nil, bundle: nil)
        print("MapKitViewProvider initialized")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        print("MapKitViewProvider viewDidLoad")
        setupSwiftUIView(content: mapKitView)
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("MapKitViewProvider viewDidAppear")
    }
    
    // MARK: PRIVATE
    
    private var mapKitView = MapKitView()
    
    /// Receive data from NativeScript
    func updateData(data: NSDictionary) {
        print("MapKitViewProvider received data: \(data)")
        
        if let action = data["action"] as? String {
            switch action {
            case "addPin":
                if let latitude = data["latitude"] as? Double,
                   let longitude = data["longitude"] as? Double,
                   let title = data["title"] as? String {
                    print("Provider: Adding pin at \(title) (\(latitude), \(longitude))")
                    // Use the main thread for UI updates
                    DispatchQueue.main.async {
                        self.mapKitView.addPin(latitude: latitude, longitude: longitude, title: title)
                    }
                } else {
                    print("Provider: Missing data for addPin action")
                }
                
            case "centerOn":
                if let latitude = data["latitude"] as? Double,
                   let longitude = data["longitude"] as? Double {
                    print("Provider: Centering map on (\(latitude), \(longitude))")
                    // Use the main thread for UI updates
                    DispatchQueue.main.async {
                        self.mapKitView.centerOn(latitude: latitude, longitude: longitude)
                    }
                } else {
                    print("Provider: Missing data for centerOn action")
                }
                
            case "centerOnUser":
                print("Provider: Centering map on user location")
                // Use the main thread for UI updates
                DispatchQueue.main.async {
                    self.mapKitView.centerOnUser()
                }
                
            default:
                print("Provider: Unknown action \(action)")
                break
            }
        }
    }
    
    /// Allow sending of data to NativeScript
    var onEvent: ((NSDictionary) -> ())?
}
