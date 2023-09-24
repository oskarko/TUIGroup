//
//  MapViewRepresentable.swift
//  TUIGroup
//
//  Created by Oscar Rodriguez Garrucho on 24/9/23
//  Linkedin: https://www.linkedin.com/in/oscar-garrucho/
//  Copyright © 2023 Oscar Rodriguez Garrucho. All rights reserved.
//

import MapKit
import SwiftUI
import UIKit

struct MapViewRepresentable: UIViewRepresentable {
    
    typealias UIViewType = MKMapView
    
    @ObservedObject private var viewModel: MapViewModel
    
    public init(viewModel: MapViewModel) {
        self.viewModel = viewModel
    }
    
    func makeCoordinator() -> MapViewCoordinator {
        return MapViewCoordinator()
    }
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.setRegion(viewModel.region, animated: true)
        
        uiView.annotations.forEach({ uiView.removeAnnotation($0) })
        uiView.addAnnotations(viewModel.placemarks)
        
        uiView.overlays.forEach({ uiView.removeOverlay($0) })
        uiView.addOverlay(viewModel.polyline)
    }
    
    class MapViewCoordinator: NSObject, MKMapViewDelegate {
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polyline = overlay as? MKPolyline {
                
                let testlineRenderer = MKPolylineRenderer(polyline: polyline)
                testlineRenderer.strokeColor = .blue
                testlineRenderer.lineWidth = 2.0
                
                return testlineRenderer
            }
            fatalError("Something wrong...")
        }
    }
}
