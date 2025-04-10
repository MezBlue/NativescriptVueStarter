// App_Resources/iOS/src/MapKitViewProvider.swift
import SwiftUI
import MapKit

@objc
class MapKitViewProvider: UIViewController, SwiftUIProvider {
    
    // Shared view model for the map.
    private var viewModel = MapKitViewModel()
    
    // Create the SwiftUI view with type erasure so that the result type is AnyView.
    private lazy var mapKitView: AnyView = {
        AnyView(MapKitView().environmentObject(viewModel))
    }()
    
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
        // Pass the AnyView to the plugin's setup function.
        setupSwiftUIView(content: mapKitView)
    }
    
    // This method is called from NativeScript (JavaScript) with a JSON dictionary.
    func updateData(data: NSDictionary) {
        print("MapKitViewProvider received data: \(data)")
        if let action = data["action"] as? String {
            switch action {
            case "addPin":
                if let latitude = data["latitude"] as? Double,
                   let longitude = data["longitude"] as? Double,
                   let title = data["title"] as? String {
                    print("Provider: Adding pin at \(title) (\(latitude), \(longitude))")
                    DispatchQueue.main.async {
                        self.viewModel.addPin(latitude: latitude, longitude: longitude, title: title)
                    }
                } else {
                    print("Provider: Missing data for addPin action")
                }
            case "centerOn":
                if let latitude = data["latitude"] as? Double,
                   let longitude = data["longitude"] as? Double {
                    print("Provider: Centering map on (\(latitude), \(longitude))")
                    DispatchQueue.main.async {
                        self.viewModel.centerOn(latitude: latitude, longitude: longitude)
                    }
                } else {
                    print("Provider: Missing data for centerOn action")
                }
            case "centerOnUser":
                print("Provider: Centering map on user location")
                DispatchQueue.main.async {
                    self.viewModel.centerOnUser()
                }
            default:
                print("Provider: Unknown action \(action)")
            }
        }
    }
    
    // Optional callback for sending data back to NativeScript (if needed).
    var onEvent: ((NSDictionary) -> ())?
}
