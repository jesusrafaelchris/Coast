//
//  InfoPage.swift
//  KeyloopCarApp
//
//  Created by Christian Grinling on 20/02/2022.
//

import UIKit
import MapKit

class InfoPage: UIViewController {
    
    var lat: Double?
    var long: Double?
    var name: String?
    var openingtime:String?
    var closingtime:String?
    
    lazy var mapview: MKMapView = {
        let mapView = MKMapView()
        mapView.mapType = MKMapType.standard
        mapView.isZoomEnabled = false
        mapView.isScrollEnabled = false
        mapView.layer.cornerRadius = 10
        mapView.layer.masksToBounds = true
        mapView.backgroundColor = .green
        return mapView
    }()
    
    lazy var openhours: UILabel = {
        let text = UILabel()
        if let openingtime = openingtime {
            if let closingtime = closingtime {
                text.layout(colour: .black, size: 16, text: "Hours: \(openingtime) - \(closingtime)", bold: true)
            }
        }
        //text.numberOfLines = 0
        text.adjustsFontSizeToFitWidth = true
        return text
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupView()
        self.title = name
        mapsetup()
    }
    
    func mapsetup() {
        if let name = name {
            if let lat = lat {
                if let long = long {
                    centerMapOnLocation(location: CLLocation(latitude: lat, longitude: long),title: name)
                }
            }
        }
    }
    
    func setupView() {
        
        view.addSubview(mapview)
        view.addSubview(openhours)
        
        mapview.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 10, bottom: nil, paddingBottom: 0, left: nil, paddingLeft: 0, right: nil, paddingRight: 0, width: 0, height: 0)
        mapview.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3).isActive = true
        mapview.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85).isActive = true
        mapview.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        openhours.anchor(top: mapview.bottomAnchor, paddingTop: 20, bottom: nil, paddingBottom: 0, left: view.leftAnchor, paddingLeft: 25, right: nil, paddingRight: 0, width: 0, height: 0)
    }
    
    func centerMapOnLocation(location: CLLocation,title:String) {
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        DispatchQueue.main.async {
            self.mapview.setRegion(region, animated: false)
            let annotation = MKPointAnnotation()
            annotation.coordinate = location.coordinate
            annotation.title = title
            self.mapview.addAnnotation(annotation)
        }
    }
    
}
