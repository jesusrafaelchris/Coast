//
//  getaddressview.swift
//  KeyloopCarApp
//
//  Created by Christian Grinling on 15/02/2022.
//

import UIKit
import GooglePlaces
import MapKit
import FirebaseAuth
import FirebaseFirestore
import Firebase


class submitAddress: UIViewController {
    
    var longitude: Double?
    var latitude: Double?
    var address: String?
    
    lazy var mapview: MKMapView = {
        let mapView = MKMapView()
        mapView.mapType = MKMapType.standard
        mapView.isZoomEnabled = false
        mapView.isScrollEnabled = false
        mapView.layer.cornerRadius = 10
        mapView.layer.masksToBounds = true
        return mapView
    }()
    
    lazy var nicknameTitle: UILabel = {
        let label = UILabel()
        label.layout(colour: .black, size: 20, text: "Choose a nickname", bold: true)
        return label
    }()
    
    lazy var nicknametextfield: UITextField = {
        let textfield = UITextField()
        textfield.layout(placeholder: "   Add a nickname", backgroundcolour: UIColor(hexString: "EEEEEE"), bordercolour: .clear, borderWidth: 0, cornerRadius: 0)
        return textfield
    }()
    
    let donebutton = darkblackbutton.textstring(text: "Add Address")

      override func viewDidLoad() {
          view.backgroundColor = .white
          self.navigationItem.backBarButtonItem?.title = ""
          self.title = "Add Address"
          guard let latitude = latitude else {return}
          guard let longitude = longitude else {return}
          guard let address = address else {return}
          let location:CLLocation = CLLocation(latitude: latitude, longitude: longitude)
          centerMapOnLocation(location: location, title: address)
          setupView()
          donebutton.addTarget(self, action: #selector(addAddress), for: .touchUpInside)
          view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismisskeyboard)))
      }
      
      @objc func dismisskeyboard() {
          //when the view is pressed dismiss all keyboards
          nicknametextfield.resignFirstResponder()
      }
    
    @objc func addAddress() {
        guard let latitude = latitude else {return}
        guard let longitude = longitude else {return}
        guard let address = address else {return}
        guard let nickname = nicknametextfield.text else {return}
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let ref = Firestore.firestore().collection("users").document(uid).collection("SavedPlaces").document()
        let data: [String:Any] = ["Address": address, "Name": nickname,"lat":latitude,"long":longitude,"documentID":ref.documentID]
        ref.setData(data, completion: { error in
            if error != nil {
                print(error!.localizedDescription)
            }
            else {
                self.navigationController?.popToRootViewController(animated: true)
            }
        })
        
        let userref = Firestore.firestore().collection("users").document(uid)
        userref.setData(["currentlocation":ref.documentID], merge: true)
    }
    
    func setupView() {
        view.addSubview(mapview)
        view.addSubview(nicknameTitle)
        view.addSubview(nicknametextfield)
        view.addSubview(donebutton)
        
        mapview.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 5, bottom: nil, paddingBottom: 0, left: view.leftAnchor, paddingLeft: 20, right: view.rightAnchor, paddingRight: 20, width: 0, height: 0)
        mapview.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3).isActive = true
        
        nicknameTitle.anchor(top: mapview.bottomAnchor, paddingTop: 20, bottom: nil, paddingBottom: 0, left: view.leftAnchor, paddingLeft: 20, right: nil, paddingRight: 20, width: 0, height: 0)
        
        nicknametextfield.anchor(top: nicknameTitle.bottomAnchor, paddingTop: 10, bottom: nil, paddingBottom: 0, left: view.leftAnchor, paddingLeft: 20, right: view.rightAnchor, paddingRight: 20, width: 0, height: 40)
        //nicknametextfield.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6).isActive = true
        
        donebutton.anchor(top: nil, paddingTop: 10, bottom: view.bottomAnchor, paddingBottom: 50, left: nil, paddingLeft: 20, right: nil, paddingRight: 20, width: 0, height: 0)
        donebutton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        donebutton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6).isActive = true
        donebutton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.12).isActive = true
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

