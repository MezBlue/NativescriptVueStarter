// App_Resources/iOS/src/MapKitView.swift
import SwiftUI
import MapKit
import CoreLocation

struct MapKitView: View {
    // Obtain the view model from the environment.
    @EnvironmentObject var viewModel: MapKitViewModel
    
    var body: some View {
        // Binding for the region.
        let regionBinding = Binding<MKCoordinateRegion>(
            get: { viewModel.region },
            set: { newRegion in viewModel.region = newRegion }
        )
        
        // The Map initializer includes showsUserLocation and tracking mode.
        return Map(
            coordinateRegion: regionBinding,
            interactionModes: .all,
            showsUserLocation: true,
            userTrackingMode: .constant(.none),
            annotationItems: viewModel.annotations
        ) { annotation in
            MapMarker(coordinate: annotation.coordinate, tint: .red)
        }
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            print("MapKitView appeared")
            viewModel.requestLocationPermission()
        }
    }
}

// View model for the map.
class MapKitViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    
    // The list of pins.
    @Published var annotations: [MapAnnotation] = []
    // The map's center coordinate.
    @Published var center: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
    // The map's zoom span.
    @Published var span: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    
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
                print("MapKitViewModel: User location not available")
            }
        }
    }
    
    // Called when location updates.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let latest = locations.last {
            print("MapKitViewModel: User location updated: \(latest.coordinate.latitude), \(latest.coordinate.longitude)")
        }
    }
}

// Annotation model defined inline.
struct MapAnnotation: Identifiable {
    let id: String
    let coordinate: CLLocationCoordinate2D
    let title: String
}
