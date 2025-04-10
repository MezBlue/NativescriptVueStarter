// App_Resources/iOS/src/MapKitViewModel.swift
import SwiftUI
import MapKit
import CoreLocation

class MapKitViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    
    // Annotations for pins.
    @Published var annotations: [MapAnnotation] = []
    // The center of the map.
    @Published var center: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
    // The span (zoom level) of the map.
    @Published var span: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    
    // Computed region property.
    var region: MKCoordinateRegion {
        get { MKCoordinateRegion(center: center, span: span) }
        set {
            center = newValue.center
            span = newValue.span
        }
    }
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func requestLocationPermission() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func addPin(latitude: Double, longitude: Double, title: String) {
        DispatchQueue.main.async {
            let annotation = MapAnnotation(
                id: UUID().uuidString,
                coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
                title: title
            )
            self.annotations.append(annotation)
            // Optionally center on the new pin.
            self.center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
    }
    
    func centerOn(latitude: Double, longitude: Double) {
        DispatchQueue.main.async {
            self.center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
    }
    
    func centerOnUser() {
        DispatchQueue.main.async {
            if let loc = self.locationManager.location {
                self.center = loc.coordinate
            } else {
                print("MapKitViewModel: User location not yet available")
            }
        }
    }
    
    // CLLocationManagerDelegate method.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let last = locations.last {
            print("MapKitViewModel: Updated user location: \(last.coordinate.latitude), \(last.coordinate.longitude)")
        }
    }
}

// Define the annotation model inline so nothing is missing.
struct MapAnnotation: Identifiable {
    let id: String
    let coordinate: CLLocationCoordinate2D
    let title: String
}
