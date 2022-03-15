//
//  ChooseLocationSheet.swift
//  KeyloopCarApp
//
//  Created by Christian Grinling on 03/02/2022.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import Firebase
import GooglePlaces
import SwipeCellKit

class ChooseLocationSheet: UIViewController, UISearchBarDelegate {
    
    var currentlocationlat: Double?
    var currentlocationlong: Double?
    weak var delegate: addressDelegate?
    
    var addresses = [addressStruct]()
    
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = UISearchBar.Style.prominent
        searchBar.placeholder = " Add a new address"
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
        return searchBar
    }()
    
    lazy var currentlocationtitle: UILabel = {
        let text = UILabel()
        text.layout(colour: .black, size: 14, text: "Current Location", bold: true)
        text.adjustsFontSizeToFitWidth = true
        text.isUserInteractionEnabled = true
        return text
    }()
    
    let arrowimage: UIButton = {
        let button = UIButton()
        button.layout(textcolour: nil , backgroundColour: UIColor(hexString: "F6F6F6"), size: nil, text: "", image: UIImage(systemName: "location.fill")?.withTintColor(UIColor(hexString: "222222")).withRenderingMode(.alwaysOriginal), cornerRadius: 20)
        return button
    }()
    
    lazy var currentlocationlabel: UILabel = {
        let text = UILabel()
        text.layout(colour: .black, size: 14, text: "Current Location", bold: true)
        text.adjustsFontSizeToFitWidth = true
        text.isUserInteractionEnabled = true
        return text
    }()
    
    lazy var addresslabel: UILabel = {
        let text = UILabel()
        text.layout(colour: .gray, size: 12, text: "Address not Found", bold: false)
        text.adjustsFontSizeToFitWidth = true
        return text
    }()
    
    
    lazy var myLocationsTitle: UILabel = {
        let text = UILabel()
        text.layout(colour: .black, size: 14, text: "My Places", bold: true)
        text.adjustsFontSizeToFitWidth = true
        return text
    }()
    
    lazy var AddressCollectionView: SelfSizedCollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionview = SelfSizedCollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionview.register(addressCell.self, forCellWithReuseIdentifier: "addressCell")
        collectionview.delegate = self
        collectionview.dataSource = self
        collectionview.backgroundColor = .clear
        collectionview.layer.cornerRadius = 0
        collectionview.layer.masksToBounds = true
        collectionview.isScrollEnabled = true
        collectionview.isUserInteractionEnabled = true
        return collectionview
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Choose Location"
        view.backgroundColor = .white
        setupView()
        guard let lat = currentlocationlat else {return}
        guard let long = currentlocationlong else {return}
        
        getAddressFromLatLon(pdblLatitude: lat, withLongitude: long) { address in
            self.addresslabel.text = "\(address.street) \(address.postalCode)"
        }
        getSavedAddresses()
        
        currentlocationtitle.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectcurrentlocation)))
        
        currentlocationlabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectcurrentlocation)))
        
    }
    
    @objc func selectcurrentlocation() {
        setchosenlocation(location: "CurrentLocation")
        if let delegate = self.delegate {
            delegate.updateselectedlocation(documentID: "CurrentLocation")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getSavedAddresses()
    }
    
    // Present the Autocomplete view controller when the button is pressed.
    @objc func autocompleteClicked() {
      let autocompleteController = GMSAutocompleteViewController()
      autocompleteController.delegate = self
      present(autocompleteController, animated: true, completion: nil)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //need more logic here
        autocompleteClicked()
    }
    
    func getSavedAddresses() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let ref  = Firestore.firestore().collection("users").document(uid).collection("SavedPlaces")
        
        ref.getDocuments { snapshot, error in
            if error != nil {
                print(error!.localizedDescription)
            }
            self.addresses.removeAll()
            guard let documents = snapshot?.documents else {return}
            for document in documents {
                let data = document.data()
                let address = addressStruct(dictionary: data)
                self.addresses.append(address)
                DispatchQueue.main.async {
                    self.AddressCollectionView.reloadData()
                }
            }
        }
    }
    
    func setupView() {
        view.addSubview(searchBar)
        
        view.addSubview(currentlocationtitle)
        view.addSubview(arrowimage)
        view.addSubview(currentlocationlabel)
        view.addSubview(addresslabel)
        
        view.addSubview(myLocationsTitle)
        view.addSubview(AddressCollectionView)

        
        searchBar.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 0, bottom: nil, paddingBottom: 0, left: view.leftAnchor, paddingLeft: 20, right: view.rightAnchor, paddingRight: 20, width: 0, height: 40)
        
        currentlocationtitle.anchor(top: searchBar.bottomAnchor, paddingTop: 5, bottom: nil, paddingBottom: 0, left: view.leftAnchor, paddingLeft: 20, right: nil, paddingRight: 10, width: 0, height: 50)
        
        
        arrowimage.anchor(top: currentlocationtitle.bottomAnchor, paddingTop: 10, bottom: nil, paddingBottom: 0, left: view.leftAnchor, paddingLeft: 20, right: nil, paddingRight: 10, width: 40, height: 40)
        
        currentlocationlabel.anchor(top: arrowimage.topAnchor, paddingTop: 0, bottom: arrowimage.centerYAnchor, paddingBottom: 0, left: arrowimage.rightAnchor, paddingLeft: 20, right: nil, paddingRight: 10, width: 0, height: 0)
        
        addresslabel.anchor(top: currentlocationlabel.bottomAnchor, paddingTop: 0, bottom: arrowimage.bottomAnchor, paddingBottom: 0, left: arrowimage.rightAnchor, paddingLeft: 20, right: nil, paddingRight: 10, width: 0, height: 0)
        
        myLocationsTitle.anchor(top: addresslabel.bottomAnchor, paddingTop: 5, bottom: nil, paddingBottom: 0, left: view.leftAnchor, paddingLeft: 20, right: nil, paddingRight: 10, width: 0, height: 50)
        
        AddressCollectionView.anchor(top: myLocationsTitle.bottomAnchor, paddingTop: 5, bottom: view.bottomAnchor, paddingBottom: 0, left: view.leftAnchor, paddingLeft: 0, right: view.rightAnchor, paddingRight: 10, width: 0, height: 0)

        
    }

}

//MARK: COLLECTIOVIEW DELEGATE
extension ChooseLocationSheet: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return addresses.count
     }
     
     func numberOfSections(in collectionView: UICollectionView) -> Int {
         return 1
     }
     
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "addressCell", for: indexPath) as! addressCell

         let address = addresses[indexPath.item]
         cell.addresslabel.text = address.Address
         cell.locationName.text = address.Name
         cell.delegate = self


         return cell
     }
     
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
         let itemWidth = collectionView.bounds.width
         let itemheight = view.bounds.height / 9
         let itemSize = CGSize(width: itemWidth, height: itemheight)
         return itemSize // Replace with count of your data for collectionViewA
     }

     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
             return 5

     }

     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
         return 5
     }
     
     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         let address = addresses[indexPath.item]
         print("selected")
         guard let documentID = address.documentID else {return}
         setchosenlocation(location: documentID)
         if let delegate = self.delegate {
             print("doin delegate shii")
             delegate.updateselectedlocation(documentID: documentID)
         }

        }
    
    func setchosenlocation(location: String) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let userref = Firestore.firestore().collection("users").document(uid)
        userref.setData(["currentlocation":location], merge: true) { error in
            if error != nil {
                print(error!.localizedDescription)
            }
            else {
                self.dismiss(animated: true, completion: nil)
               }
           }
        }
     }

extension ChooseLocationSheet: GMSAutocompleteViewControllerDelegate {

  // Handle the user's selection.
  func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
      dismiss(animated: true) {
          let submitaddress = submitAddress()
          submitaddress.longitude = place.coordinate.longitude
          submitaddress.latitude = place.coordinate.latitude
          submitaddress.address = place.formattedAddress
          self.navigationController?.pushViewController(submitaddress, animated: true)
      }
  }

  func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
    // TODO: handle the error.
    print("Error: ", error.localizedDescription)
  }

  // User canceled the operation.
  func wasCancelled(_ viewController: GMSAutocompleteViewController) {
    dismiss(animated: true, completion: nil)
  }

  // Turn the network activity indicator on and off again.
  func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
    UIApplication.shared.isNetworkActivityIndicatorVisible = true
  }

  func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
    UIApplication.shared.isNetworkActivityIndicatorVisible = false
  }

}

extension ChooseLocationSheet: SwipeCollectionViewCellDelegate {
    
    func collectionView(_ collectionView: UICollectionView, editActionsForItemAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            self.addresses.remove(at: indexPath.item)
            let address = self.addresses[indexPath.item]
            guard let uid = Auth.auth().currentUser?.uid else {return}
            guard let document = address.documentID else {return}
            let ref = Firestore.firestore().collection("users").document(uid).collection("SavedPlaces").document(document)
            ref.delete()
//            DispatchQueue.main.async {
//                self.AddressCollectionView.reloadData()
//            }
        }

        // customize the action appearance
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.hidesWhenSelected = true

        return [deleteAction]
    }
}



class addressStruct: NSObject {
    
    var Name: String?
    var Address: String?
    var lat: Double?
    var long: Double?
    var documentID: String?
    
    init(dictionary: [String:Any]) {
        super.init()
        
        Name = dictionary["Name"] as? String
        Address = dictionary["Address"] as? String
        
        lat = dictionary["lat"] as? Double
        long = dictionary["long"] as? Double
        
        documentID = dictionary["documentID"] as? String
    }
}
