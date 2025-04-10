import SwiftUI
import MapKit

struct MapKitView: View {
    @StateObject private var viewModel = MapKitViewModel()
    
    var body: some View {
        // Create a binding for the region that will update when center or span changes
        let regionBinding = Binding<MKCoordinateRegion>(
            get: { viewModel.region },
            set: { viewModel.region = $0 }
        )
        
        return Map(coordinateRegion: regionBinding, showsUserLocation: true, annotationItems: viewModel.annotations) { annotation in
            MapMarker(coordinate: annotation.coordinate, tint: .red)
        }
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            print("MapKitView appeared")
            viewModel.requestLocationPermission()
        }
    }
    
    // Function to add a pin to the map
    func addPin(latitude: Double, longitude: Double, title: String) {
        print("SwiftUI: Adding pin at \(title) (\(latitude), \(longitude))")
        viewModel.addPin(latitude: latitude, longitude: longitude, title: title)
    }
    
    // Function to center the map on a specific location
    func centerOn(latitude: Double, longitude: Double) {
        print("SwiftUI: Centering map on (\(latitude), \(longitude))")
        viewModel.centerOn(latitude: latitude, longitude: longitude)
    }
    
    // Function to center on user's location
    func centerOnUser() {
        print("SwiftUI: Centering map on user location")
        viewModel.centerOnUser()
    }
}

// ViewModel to handle state updates properly
class MapKitViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    @Published var location: CLLocation?
    
    // Use a separate property for the center to force view updates
    @Published var center: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
    @Published var span: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    
    // Computed property for region that depends on center and span
    var region: MKCoordinateRegion {
        get {
            return MKCoordinateRegion(center: center, span: span)
        }
        set {
            center = newValue.center
            span = newValue.span
        }
    }
    
    @Published var annotations: [MapAnnotation] = []
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        print("MapKitViewModel initialized")
    }
    
    func requestLocationPermission() {
        print("Requesting location permission")
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func addPin(latitude: Double, longitude: Double, title: String) {
        print("ViewModel: Adding pin at \(title) (\(latitude), \(longitude))")
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            let newAnnotation = MapAnnotation(
                id: UUID().uuidString,
                coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
                title: title
            )
            
            // Create a new array to force a UI update
            var updatedAnnotations = self.annotations
            updatedAnnotations.append(newAnnotation)
            self.annotations = updatedAnnotations
            
            print("Pin added, total annotations: \(self.annotations.count)")
            
            // Also center on the new pin
            self.centerOn(latitude: latitude, longitude: longitude)
        }
    }
    
    func centerOn(latitude: Double, longitude: Double) {
        print("ViewModel: Centering map on (\(latitude), \(longitude))")
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            // Update the center to force a UI update
            self.center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            print("Map centered on new location")
        }
    }
    
    func centerOnUser() {
        print("ViewModel: Centering map on user location")
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            if let location = self.location {
                print("User location found: \(location.coordinate.latitude), \(location.coordinate.longitude)")
                self.center = location.coordinate
            } else {
                print("User location not available yet")
                // Start updating location if we don't have it yet
                self.locationManager.startUpdatingLocation()
            }
        }
    }
    
    // CLLocationManagerDelegate method
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.location = location
    }
}

// Model for map annotations
struct MapAnnotation: Identifiable {
    let id: String
    let coordinate: CLLocationCoordinate2D
    let title: String
}
