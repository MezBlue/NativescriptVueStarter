// App_Resources/iOS/src/MapKitViewProvider.swift
import SwiftUI
import MapKit
import CoreLocation

@objc(MapKitViewProvider)
class MapKitViewProvider: UIViewController, SwiftUIProvider {
    
    // A simple class to hold our view model.
    class MapKitProps: NSObject {
        @objc var viewModel = MapKitViewModel()
    }
    
    // Create a props object.
    private var props = MapKitProps()
    
    // Create the SwiftUI view and inject the view model via environmentObject.
    // Type-erased to AnyView for compatibility.
    private lazy var swiftUIView: AnyView = {
        AnyView(MapKitSampleView(props: props).environmentObject(props.viewModel))
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
        setupSwiftUIView(content: swiftUIView)
    }
    
    /// Receives data from NativeScript. Mimics the sample:
    /// - "addPin" expects latitude, longitude, title.
    /// - "centerOn" expects latitude, longitude.
    /// - "centerOnUser" needs no extra data.
    func updateData(data: NSDictionary) {
        print("MapKitViewProvider received data: \(data)")
        if let action = data.value(forKey: "action") as? String {
            switch action {
            case "addPin":
                if let latitude = data.value(forKey: "latitude") as? Double,
                   let longitude = data.value(forKey: "longitude") as? Double,
                   let title = data.value(forKey: "title") as? String {
                    print("Provider: Adding pin at \(title) (\(latitude), \(longitude))")
                    DispatchQueue.main.async {
                        self.props.viewModel.addPin(latitude: latitude, longitude: longitude, title: title)
                    }
                    self.onEvent?(["status": "pinAdded"])
                } else {
                    print("Provider: Missing data for addPin")
                }
            case "centerOn":
                if let latitude = data.value(forKey: "latitude") as? Double,
                   let longitude = data.value(forKey: "longitude") as? Double {
                    print("Provider: Centering map on (\(latitude), \(longitude))")
                    DispatchQueue.main.async {
                        self.props.viewModel.centerOn(latitude: latitude, longitude: longitude)
                    }
                    self.onEvent?(["status": "centered"])
                } else {
                    print("Provider: Missing data for centerOn")
                }
            case "centerOnUser":
                print("Provider: Centering map on user location")
                DispatchQueue.main.async {
                    self.props.viewModel.centerOnUser()
                }
                self.onEvent?(["status": "centeredOnUser"])
            default:
                print("Provider: Unknown action \(action)")
            }
        }
    }
    
    /// Callback for sending events back to NativeScript (if needed).
    var onEvent: ((NSDictionary) -> Void)?
}

// MARK: - MapKitSampleView

// This view simply wraps MapKitView. You can expand this view if needed.
struct MapKitSampleView: View {
    var props: MapKitViewProvider.MapKitProps
    
    var body: some View {
        MapKitView()
    }
}
