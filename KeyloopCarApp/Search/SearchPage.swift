//
//  SearchPage.swift
//  KeyloopCarApp
//
//  Created by Christian Grinling on 02/02/2022.
//

import UIKit
import DropDown
import Firebase
import CoreLocation
import Nuke
import Geofirestore

protocol addressDelegate: AnyObject {
    
    func updateselectedlocation(documentID: String)
    
}

class SearchPage: UIViewController, UISearchBarDelegate, addressDelegate {

    let locationManager = CLLocationManager()
    var garages = [GarageInfoData]()
    var featuredgarages = [GarageInfoData]()
    var filteredgarages: [GarageInfoData]?
    var distanceInMiles: String = ""
    var numberplate: String?
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.bounces = true
        scrollView.isScrollEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    lazy var numberplatedropdownbutton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 170, height: 50))
        button.layout(textcolour: .black, backgroundColour: .clear, size: 12, text: "  ", image: UIImage(systemName: "car")?.withTintColor(.black).withRenderingMode(.alwaysOriginal), cornerRadius: 0)
        return button
    }()
    
    lazy var categoryscrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.bounces = true
        scrollView.isScrollEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    lazy var locationbutton: UIButton = {
        let button = UIButton()
        button.layout(textcolour: .black, backgroundColour: .clear, size: 14, text: "", image: UIImage(systemName: "location.fill")?.withTintColor(.black).withRenderingMode(.alwaysOriginal), cornerRadius: 20)
        button.layer.borderColor = UIColor(hexString: "F6F5F8").cgColor
        button.layer.borderWidth = 2
        return button
    }()
    
    lazy var searchbutton: UIButton = {
        let button = UIButton()
        button.setsizedImage(symbol: "magnifyingglass", size: 16, colour: .black)
        return button
    }()
    
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = UISearchBar.Style.prominent
        searchBar.placeholder = " Search..."
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
        return searchBar
    }()
    
    lazy var BrowseGarages: UILabel = {
        let text = UILabel()
        text.layout(colour: .black, size: 28, text: "Browse Garages", bold: true)
        return text
    }()
    
    lazy var allcategory = SearchPageCategoryButton.settext(text: "All",tag: 0)
    lazy var MOTcategory = SearchPageCategoryButton.settext(text: "Price",tag: 1)
    lazy var tyrecategory = SearchPageCategoryButton.settext(text: "Radius",tag: 2)
    lazy var brakescategory = SearchPageCategoryButton.settext(text: "Rating",tag: 3)
    lazy var airconcategory = SearchPageCategoryButton.settext(text: "Time",tag: 4)
    lazy var morecategory = SearchPageCategoryButton.settext(text: "More",tag: 5)
    
    lazy var categorystack = equalStackView.layoutcategoryButtons(buttons: [allcategory,MOTcategory,tyrecategory,brakescategory,airconcategory,morecategory])
    
    lazy var FeaturedGarages: UILabel = {
        let text = UILabel()
        text.layout(colour: .black, size: 18, text: "Featured Garages near you", bold: true)
        return text
    }()
    
    lazy var FeaturedGaragesCollectionView: SelfSizedCollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionview = SelfSizedCollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionview.register(FeaturedGarageCell.self, forCellWithReuseIdentifier: "featuredgarageCell")
        collectionview.delegate = self
        collectionview.dataSource = self
        collectionview.backgroundColor = .clear
        collectionview.layer.cornerRadius = 0
        collectionview.layer.masksToBounds = true
        collectionview.isScrollEnabled = true
        collectionview.showsHorizontalScrollIndicator = false
        //collectionview.backgroundColor = .red
        return collectionview
    }()
    
    lazy var TopGarages: UILabel = {
        let text = UILabel()
        text.layout(colour: .black, size: 18, text: "Top Garages", bold: true)
        return text
    }()
    
    
    lazy var GaragesCollectionView: SelfSizedCollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionview = SelfSizedCollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionview.register(GarageCell.self, forCellWithReuseIdentifier: "garageCell")
        collectionview.delegate = self
        collectionview.dataSource = self
        collectionview.backgroundColor = .clear
        collectionview.layer.cornerRadius = 0
        collectionview.layer.masksToBounds = true
        collectionview.isScrollEnabled = true
        return collectionview
    }()
    
    
    let dropDown = DropDown()
    var numberplates = [String]()
    var userlat = CLLocationDegrees()
    var userlong = CLLocationDegrees()
    var chosenlat = CLLocationDegrees()
    var chosenlong = CLLocationDegrees()
    var selectedCategory = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupDropdown()
        setupnavbar()
        getcarlist()
        getcurrentcar()
        setupView()
        setupLocation()
        buttonTargetSetup()
        select(button: allcategory)

    }
    
    func select(button:SearchPageCategoryButton) {
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = UIColor(hexString: "222222")
        }
    
    func unselect(button:SearchPageCategoryButton)  {
            button.setTitleColor(.black, for: .normal)
            button.backgroundColor = UIColor(hexString: "F6F6F6")
        }
    
    func buttonTargetSetup() {
        searchbutton.addTarget(self, action: #selector(showsearchbar), for: .touchUpInside)
        searchBar.searchTextField.clearButton?.addTarget(self, action: #selector(dismisskeyboard), for: .touchUpInside) //bllah
        locationbutton.addTarget(self, action: #selector(chooselocation), for: .touchUpInside)
        
        allcategory.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        MOTcategory.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        tyrecategory.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        brakescategory.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        airconcategory.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        morecategory.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        
    }
    
    func getbuttonfromtag(tag: Int) -> SearchPageCategoryButton {
        switch tag {
            case 0:
                return allcategory
        
            case 1:
                return MOTcategory
                
            case 2:
                return tyrecategory
                
            case 3:
                return brakescategory
                
            case 4:
                return airconcategory
        
            case 5:
                return morecategory
            
        default:
            return allcategory
            
        }
    }
    
    @objc func buttonPressed(_ sender: UIButton) {
        print("Button \(sender.tag) was pressed")
        unselect(button: getbuttonfromtag(tag: selectedCategory))
        select(button: getbuttonfromtag(tag: sender.tag))
        selectedCategory = sender.tag
    }
    
    func updateselectedlocation(documentID: String) {
        self.garages.removeAll()
        self.filteredgarages?.removeAll()
        self.featuredgarages.removeAll()
        DispatchQueue.main.async {
            self.GaragesCollectionView.reloadData()
            self.FeaturedGaragesCollectionView.reloadData()
        }
        
        
        print(documentID)
        if documentID == "CurrentLocation" {
            print("selected address is current")
            //if selected is current
            self.setgaragesandlocationtitle(latitude: self.userlat, longitude: self.userlong)

        }
        else {
            print("selected address is somewhere else")
            self.currentlocationfromdocumentID(documentID: documentID) { address in
                guard let lat = address.lat else {return}
                guard let long = address.long else {return}
                self.setgaragesandlocationtitle(latitude: lat, longitude: long)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("just appeared")
        self.garages.removeAll()
        self.filteredgarages?.removeAll()
        self.featuredgarages.removeAll()
        DispatchQueue.main.async {
            self.GaragesCollectionView.reloadData()
            self.FeaturedGaragesCollectionView.reloadData()
        }
        
        addressSelectionLogic()

    }
    
    func addressSelectionLogic() {
        getselectedlocation { documentID in
            if documentID == "CurrentLocation" {
                print("selected address is current")
                //if selected is current
                self.setgaragesandlocationtitle(latitude: self.userlat, longitude: self.userlong)

            }
            else {
                print("selected address is somewhere else")
                self.currentlocationfromdocumentID(documentID: documentID) { address in
                    guard let lat = address.lat else {return}
                    guard let long = address.long else {return}
                    self.setgaragesandlocationtitle(latitude: lat, longitude: long)
                    }
                }
            }
        }
    
    @objc func chooselocation() {
        let chooselocation = ChooseLocationSheet()
        chooselocation.currentlocationlat = userlat
        chooselocation.currentlocationlong = userlong
        chooselocation.delegate = self
        
        let nav = UINavigationController(rootViewController: chooselocation)
        nav.modalPresentationStyle = .pageSheet
        if let sheet = nav.sheetPresentationController {

            sheet.detents = [ .medium()]

        }
        present(nav, animated: true, completion: nil)
    }
    
    @objc func dismisskeyboard() {
        self.searchbarwidthanchor?.isActive = false
        self.searchBar.resignFirstResponder()
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty == false {
            filteredgarages = garages.filter { garage in
                return garage.Name!.lowercased().contains(searchText.lowercased())
            }
        }
        else {self.filteredgarages = self.garages}

        DispatchQueue.main.async {
            self.GaragesCollectionView.reloadData()
        }
    }
    
    @objc func showsearchbar() {
        
        self.searchbarwidthanchor?.isActive = true
        self.searchBar.becomeFirstResponder()

    }
    
    func setupLocation() {
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()

        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }

    }
    
    var searchbarwidthanchor: NSLayoutConstraint?
    
    func setupView() {
        view.addSubview(scrollView)
        scrollView.addSubview(locationbutton)
        scrollView.addSubview(searchbutton)
        scrollView.addSubview(searchBar)
        scrollView.addSubview(BrowseGarages)
        scrollView.addSubview(categoryscrollView)
        categoryscrollView.addSubview(categorystack)
        scrollView.addSubview(FeaturedGarages)
        scrollView.addSubview(FeaturedGaragesCollectionView)
        scrollView.addSubview(TopGarages)
        scrollView.addSubview(GaragesCollectionView)

        scrollView.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 0, bottom: view.bottomAnchor, paddingBottom: 0, left: view.leftAnchor, paddingLeft: 0, right: view.rightAnchor, paddingRight: 0, width: 0, height: 0)
        
        locationbutton.anchor(top: scrollView.topAnchor, paddingTop: 0, bottom: nil, paddingBottom: 0, left: view.leftAnchor, paddingLeft: 10, right: nil, paddingRight: 0, width: 0, height: 0)
        locationbutton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.32).isActive = true
        locationbutton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05).isActive = true
        
        searchbutton.anchor(top: nil, paddingTop: 0, bottom: nil, paddingBottom: 0, left: nil, paddingLeft: 0, right: view.rightAnchor, paddingRight: 20, width: 0, height: 0)
        searchbutton.centerYAnchor.constraint(equalTo: locationbutton.centerYAnchor).isActive = true
        //searchbutton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05).isActive = true
        
        searchBar.anchor(top: nil, paddingTop: 0, bottom: nil, paddingBottom: 0, left: nil, paddingLeft: 0, right: view.rightAnchor, paddingRight: 10, width: 0, height: 0)
        searchBar.centerYAnchor.constraint(equalTo: locationbutton.centerYAnchor).isActive = true
        searchbarwidthanchor = searchBar.widthAnchor.constraint(equalTo: view.widthAnchor,multiplier: 0.6)
        searchbarwidthanchor?.isActive = false
        
        BrowseGarages.anchor(top: searchBar.bottomAnchor, paddingTop: 10, bottom: nil, paddingBottom: 0, left: view.leftAnchor, paddingLeft: 20, right: nil, paddingRight: 10, width: 0, height: 0)
        
        categoryscrollView.anchor(top: BrowseGarages.bottomAnchor, paddingTop: 15, bottom: nil, paddingBottom: 0, left: view.leftAnchor, paddingLeft: 20, right: view.rightAnchor, paddingRight: 0, width: 0, height: 0)
        categoryscrollView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05).isActive = true
        
        categorystack.anchor(top: nil, paddingTop: 0, bottom: nil, paddingBottom: 0, left: categoryscrollView.leftAnchor, paddingLeft: 0, right: categoryscrollView.rightAnchor, paddingRight: 0, width: 0, height: 0)
        categorystack.centerYAnchor.constraint(equalTo: categoryscrollView.centerYAnchor).isActive = true
        
        let categoryHeight = CGFloat(30)
        let categoryWidth = CGFloat(70)
        
        NSLayoutConstraint.activate([
            allcategory.widthAnchor.constraint(equalToConstant: categoryWidth),
            MOTcategory.widthAnchor.constraint(equalToConstant: categoryWidth),
            tyrecategory.widthAnchor.constraint(equalToConstant: categoryWidth),
            brakescategory.widthAnchor.constraint(equalToConstant: categoryWidth),
            airconcategory.widthAnchor.constraint(equalToConstant: categoryWidth),
            morecategory.widthAnchor.constraint(equalToConstant: categoryWidth),
            
            allcategory.heightAnchor.constraint(equalToConstant: categoryHeight),
            MOTcategory.heightAnchor.constraint(equalToConstant: categoryHeight),
            tyrecategory.heightAnchor.constraint(equalToConstant: categoryHeight),
            brakescategory.heightAnchor.constraint(equalToConstant: categoryHeight),
            airconcategory.heightAnchor.constraint(equalToConstant: categoryHeight),
            morecategory.heightAnchor.constraint(equalToConstant: categoryHeight),
        ])
        
        FeaturedGarages.anchor(top: categoryscrollView.bottomAnchor, paddingTop: 15, bottom: nil, paddingBottom: 0, left: view.leftAnchor, paddingLeft: 20, right: nil, paddingRight: 10, width: 0, height: 0)
        
        FeaturedGaragesCollectionView.anchor(top: FeaturedGarages.bottomAnchor, paddingTop: 20, bottom: nil, paddingBottom: 0, left: view.leftAnchor, paddingLeft: 20, right: view.rightAnchor, paddingRight: 20, width: 0, height: 0)
        FeaturedGaragesCollectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.28).isActive = true
        
        TopGarages.anchor(top: FeaturedGaragesCollectionView.bottomAnchor, paddingTop: 15, bottom: nil, paddingBottom: 0, left: view.leftAnchor, paddingLeft: 20, right: nil, paddingRight: 10, width: 0, height: 0)
        
        GaragesCollectionView.anchor(top: TopGarages.bottomAnchor, paddingTop: 20, bottom: scrollView.bottomAnchor, paddingBottom: 0, left: view.leftAnchor, paddingLeft: 20, right: view.rightAnchor, paddingRight: 20, width: 0, height: 0)
        
    }
    


}

//MARK: LOCATION DELEGATE
extension SearchPage: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager,didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func setgaragesandlocationtitle(latitude: Double, longitude: Double) {
        getAddressFromLatLon(pdblLatitude: latitude, withLongitude: longitude) { address in
            self.locationbutton.setTitle("  \(address.postalCode)", for: .normal)
            self.garages.removeAll()
            self.filteredgarages?.removeAll()
            self.featuredgarages.removeAll()
            self.getgarages(lat: latitude, Lon: longitude)
            self.getfeaturedgarages(lat: latitude, Lon: longitude)
            self.locationManager.stopUpdatingLocation()
            }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            //set userlocation
        self.userlat = location.coordinate.latitude
        self.userlong = location.coordinate.longitude
            
        getselectedlocation { documentID in
            if documentID == "CurrentLocation" {
                //if selected is current
                print("selected address is current location")
                self.setgaragesandlocationtitle(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                


            }
            else {
                print("selected address is somewhere else")
                self.currentlocationfromdocumentID(documentID: documentID) { address in
                    guard let lat = address.lat else {return}
                    guard let long = address.long else {return}
                    print(lat,long)
                    self.setgaragesandlocationtitle(latitude: lat, longitude: long)
                    }
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager,didFailWithError error: Error) {
        // Handle failure to get a user’s location
    }
}

//MARK: SETUP ACTIONS

extension SearchPage {
    
    func getfeaturedgarages(lat: Double, Lon: Double) {
        let garageref = Firestore.firestore().collection("FeaturedGarages")
        let geoFirestore = GeoFirestore(collectionRef: garageref)
        
        // Query using CLLocation
        let center = CLLocation(latitude: lat, longitude: Lon)
        
        self.chosenlat = lat
        self.chosenlong = Lon
        // Query locations at [37.7832889, -122.4056973] with a radius of 16km = 10 miles
        let circleQuery = geoFirestore.query(withCenter: center, radius: 16)
        
        //self.garages.removeAll()
        let queryHandle = circleQuery.observe(.documentEntered, with: { (key, location) in
            print("featured garage at '\(location)'")
            guard let key = key else {return}
            let carlistref = Firestore.firestore().collection("Garages").document(key)
            carlistref.getDocument(completion: { snapshot, error in
            if error != nil {
                self.Alert(error!.localizedDescription)
            }
                guard let data = snapshot?.data() else {return}
                let garage = GarageInfoData(dictionary: data)
                self.featuredgarages.append(garage)
                DispatchQueue.main.async {
                    self.FeaturedGaragesCollectionView.reloadData()
                }
            })
        })
                                   
    }
    
    
    func getgarages(lat: Double, Lon: Double) {
        
        let garageref = Firestore.firestore().collection("Garages")
        let geoFirestore = GeoFirestore(collectionRef: garageref)
        print("now getting garages")

        // Query using CLLocation
        let center = CLLocation(latitude: lat, longitude: Lon)
        
        self.chosenlat = lat
        self.chosenlong = Lon
        // Query locations at [37.7832889, -122.4056973] with a radius of 16km = 10 miles
        let circleQuery = geoFirestore.query(withCenter: center, radius: 16)
        
        //self.garages.removeAll()
        let queryHandle = circleQuery.observe(.documentEntered, with: { (key, location) in
            print("The document with documentID '\(key)' entered the search area and is at location '\(location)'")
            guard let key = key else {return}
            let carlistref = Firestore.firestore().collection("Garages").document(key)
            carlistref.getDocument(completion: { snapshot, error in
            if error != nil {
                self.Alert(error!.localizedDescription)
            }
                guard let data = snapshot?.data() else {return}
                let garage = GarageInfoData(dictionary: data)
                self.garages.append(garage)
                
                DispatchQueue.main.async {
                    self.filteredgarages = self.garages
                    self.GaragesCollectionView.reloadData()
                }
            })
        })
    }
    
    
    func setupnavbar() {
        numberplatedropdownbutton.addTarget(self, action: #selector(showdropdown), for: .touchUpInside)
        
        self.navigationItem.titleView = numberplatedropdownbutton
        
    }
    
    @objc func showdropdown() {
        dropDown.show()
    }
    
    func currentlocationfromdocumentID(documentID:String, completion: @escaping (addressStruct) -> Void) {
   
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let ref  = Firestore.firestore().collection("users").document(uid).collection("SavedPlaces").document(documentID)
        ref.getDocument { snapshot, error in
            if error != nil {
                print(error!.localizedDescription)
            }
            
            guard let data = snapshot?.data() else {return}
            let address = addressStruct(dictionary: data)
            completion(address)
            }
        }
    
    func getselectedlocation(completion: @escaping (String) -> Void) {
            guard let uid = Auth.auth().currentUser?.uid else {return}
            
            let ref = Firestore.firestore().collection("users").document(uid)
            ref.getDocument(completion: { snapshot, error in
                if error != nil {
                    print(error!.localizedDescription)
                }
                let data = snapshot?.data()
                let currentlocation = data?["currentlocation"] as! String
                completion(currentlocation)
            })
    }
    
    func setupDropdown() {
        dropDown.anchorView = numberplatedropdownbutton
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
          print("Selected item: \(item) at index: \(index)")
            selectcar(numberplate: item)
        }
    }
    
    func selectcar(numberplate:String) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        let ref = Firestore.firestore().collection("users").document(uid)
            ref.setData(["selectedCar":numberplate], merge: true) { error in
                if error != nil {
                    print(error!.localizedDescription)
            }
        self.numberplatedropdownbutton.setTitle("  \(numberplate)  ↓", for: .normal)
        }
    }
    
    func getcurrentcar() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        let ref = Firestore.firestore().collection("users").document(uid)
        ref.getDocument(completion: { snapshot, error in
            if error != nil {
                print(error!.localizedDescription)
            }
            let data = snapshot?.data()
            let numberplate = data?["selectedCar"] as! String
            //let currentlocation = data?["currentlocation"] as! String
            self.numberplatedropdownbutton.setTitle("  \(numberplate)  ↓", for: .normal)
            self.numberplate = numberplate
        })
    }
    
    func getcarlist() {
        if let uid = Auth.auth().currentUser?.uid {
        
        let carlistref = Firestore.firestore().collection("users").document(uid).collection("cars")
            carlistref.getDocuments { snapshot, error in
            if error != nil {
                self.Alert(error!.localizedDescription)
            }
            guard let documents = snapshot?.documents else {return}
            for document in documents {
                let numberplate = document.documentID
                self.numberplates.append(numberplate)
                }
                self.dropDown.dataSource = self.numberplates
            }
        }
    }
}

//MARK: COLLECTIOVIEW DELEGATE
extension SearchPage: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.GaragesCollectionView {
            guard let garages = filteredgarages else {
                return 0
            }
            return garages.count
        }

        return featuredgarages.count
     }
     
     func numberOfSections(in collectionView: UICollectionView) -> Int {
         return 1
     }
     
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         if collectionView == self.GaragesCollectionView {
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "garageCell", for: indexPath) as! GarageCell
         
         if let garages = filteredgarages {
         let garage = garages[indexPath.item]

         if let urlstring = garage.Image {
             if let url = URL(string: urlstring) {
                 Nuke.loadImage(with: url, into: cell.GarageImage)
             }
         }
         
         cell.GarageName.text = garage.Name
         if let rating = garage.Rating {
             cell.RatingText.setTitle(" \(rating)", for: .normal) 
         }
        
         
         let coordinate1 = CLLocation(latitude: chosenlat, longitude: chosenlong)
         
         if let glat = garage.Latitude {
             if let glong = garage.Longitude {
                 let garagelat = CLLocationDegrees(glat)
                 let garagelong = CLLocationDegrees(glong)
                 
                 let coordinate2 = CLLocation(latitude: garagelat, longitude: garagelong)
                 let DistanceInMiles = coordinate2.distance(from: coordinate1) / 1609.344
                 distanceInMiles = "\(round(DistanceInMiles * 10) / 10) miles away"
                 cell.FarAwayText.setTitle(" \(round(DistanceInMiles * 10) / 10) miles", for: .normal)
                }
            }
         }
         return cell
         }
         
         else   {
             
             let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "featuredgarageCell", for: indexPath) as! FeaturedGarageCell
             
             cell.layer.cornerRadius = 20
             cell.layer.masksToBounds = true
             
             let garage = featuredgarages[indexPath.item]

             if let urlstring = garage.Image {
                 if let url = URL(string: urlstring) {
                     Nuke.loadImage(with: url, into: cell.GarageImage)
                 }
             }
             
             cell.GarageName.text = garage.Name
             if let rating = garage.Rating {
                 cell.RatingText.setTitle(" \(rating)", for: .normal)
             }
            
             
             let coordinate1 = CLLocation(latitude: 51.49808, longitude: -2.61938)
             
             if let glat = garage.Latitude {
                 if let glong = garage.Longitude {
                     let garagelat = CLLocationDegrees(glat)
                     let garagelong = CLLocationDegrees(glong)
                     
                     let coordinate2 = CLLocation(latitude: garagelat, longitude: garagelong)
                     let DistanceInMiles = coordinate2.distance(from: coordinate1) / 1609.344
                     distanceInMiles = "\(round(DistanceInMiles * 10) / 10) miles away"
                     cell.FarAwayText.setTitle(" \(round(DistanceInMiles * 10) / 10) miles", for: .normal)
                    }
             }
             return cell
         }
     }
     
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
         
         if collectionView == self.GaragesCollectionView {
             let itemWidth = collectionView.bounds.width
             let itemheight = view.bounds.height / 12
             let itemSize = CGSize(width: itemWidth, height: itemheight)
         return itemSize // Replace with count of your data for collectionViewA
         }
         
         else {
             let itemWidth = collectionView.bounds.width
             let itemheight = view.bounds.height / 3.8
             let itemSize = CGSize(width: itemWidth, height: itemheight)
             return itemSize
         }
     }

     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
             return 20

     }

     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
         return 20
     }
     
     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         
         if collectionView == GaragesCollectionView {
             let garage = garages[indexPath.item]
             
             let detailedgarage = DetailedGarage()
             
             detailedgarage.garageID = garage.uid
             detailedgarage.faraway = distanceInMiles
             detailedgarage.rating = garage.Rating
             detailedgarage.image = garage.Image
             detailedgarage.name = garage.Name
             detailedgarage.lat = garage.Latitude
             detailedgarage.long = garage.Longitude
             detailedgarage.opentime = garage.OpeningHour
             detailedgarage.closetime = garage.ClosingHour
             detailedgarage.numberplate = self.numberplate
             
             navigationController?.pushViewController(detailedgarage, animated: true)
            }
         
         else if collectionView == FeaturedGaragesCollectionView {
             let garage = featuredgarages[indexPath.item]
             
             let detailedgarage = DetailedGarage()
             
             detailedgarage.garageID = garage.uid
             detailedgarage.faraway = distanceInMiles
             detailedgarage.rating = garage.Rating
             detailedgarage.image = garage.Image
             detailedgarage.name = garage.Name
             detailedgarage.lat = garage.Latitude
             detailedgarage.long = garage.Longitude
             detailedgarage.opentime = garage.OpeningHour
             detailedgarage.closetime = garage.ClosingHour
             detailedgarage.numberplate = self.numberplate
             
             navigationController?.pushViewController(detailedgarage, animated: true)
            }
        }
     }


////set location
//        geoFirestore.setLocation(location: CLLocation(latitude: 51.44431, longitude: -2.58908), forDocumentWithID: "ICPgiLAfcRWKkTK6D2SR") { (error) in
//            if let error = error {
//                print("An error occured: \(error)")
//            } else {
//                print("Saved location successfully!")
//            }
//        }

