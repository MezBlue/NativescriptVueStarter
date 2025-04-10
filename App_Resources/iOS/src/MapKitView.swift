// App_Resources/iOS/src/MapKitView.swift
import SwiftUI
import MapKit
import CoreLocation

struct MapKitView: View {
    // Use the shared view model from the environment.
    @EnvironmentObject var viewModel: MapKitViewModel
    
    var body: some View {
        let regionBinding = Binding<MKCoordinateRegion>(
            get: { viewModel.region },
            set: { newValue in viewModel.region = newValue }
        )
        
        return Map(coordinateRegion: regionBinding, annotationItems: viewModel.annotations) { annotation in
            MapMarker(coordinate: annotation.coordinate, tint: .red)
        }
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            print("MapKitView appeared")
            viewModel.requestLocationPermission()
        }
    }
}
