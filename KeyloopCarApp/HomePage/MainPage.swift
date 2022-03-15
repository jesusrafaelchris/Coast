//
//  ViewController.swift
//  KeyloopCarApp
//
//  Created by Christian Grinling on 03/11/2021.
//

import UIKit
import Foundation
import Firebase
import FirebaseFirestore
import Nuke
import DropDown

class MainPage: UIViewController {
    
    let numberplatecolour = UIColor(hexString: "#F9D349")
    var lightgreybordercolour = UIColor(red: 0.84, green: 0.86, blue: 0.88, alpha: 1.00)
    var numberplates = [String]()
    var MOTdata = [MOTData]()
    var MotDate: String?
    
    
    lazy var numberplatedropdownbutton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 170, height: 50))
        button.layout(textcolour: .black, backgroundColour: .clear, size: 12, text: "  ", image: UIImage(systemName: "car")?.withTintColor(.black).withRenderingMode(.alwaysOriginal), cornerRadius: 0)
        return button
    }()
    
    lazy var CoastTitle: UILabel = {
        let text = UILabel()
        text.layout(colour: .black, size: 28, text: "Coast", bold: true)
        return text
    }()
    
    lazy var CarContainerView: UIView = {
       let view = UIView()
        view.backgroundColor = .white//UIColor(hexString: "F6F6F6")
        view.layer.cornerRadius = 20
        view.layer.borderColor = lightgreybordercolour.cgColor
        view.layer.borderWidth = 1
        view.layer.masksToBounds = true
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 10
        view.layer.shadowPath = UIBezierPath(rect: view.bounds).cgPath
        return view
    }()
    
    lazy var welcomebackText: UILabel = {
        let text = UILabel()
        if let name = Auth.auth().currentUser?.displayName {
            text.layout(colour: UIColor(hexString: "5D6F85"), size: 12, text: "Welcome back \(name)", bold: false)
        }
        return text
    }()
    
    lazy var LogoImage: UIImageView = {
        let imageview = UIImageView()
        imageview.contentMode = .scaleAspectFill
        imageview.layer.masksToBounds = true
        imageview.translatesAutoresizingMaskIntoConstraints = false
        imageview.image = UIImage(named: "Logo_Black")
        return imageview
    }()
    
    lazy var MyVehicleText: UILabel = {
        let text = UILabel()
        text.layout(colour: UIColor(hexString: "707275"), size: 12, text: "MY VEHICLE", bold: false)
        
        return text
    }()
    
    lazy var MyCarText: UILabel = {
        let text = UILabel()
        text.layout(colour: .black, size: 20, text: "My Vehicle", bold: true)
        return text
    }()
    
    lazy var CarImage: UIImageView = {
        let imageview = UIImageView()
        imageview.contentMode = .scaleAspectFill
        imageview.layer.masksToBounds = true
        imageview.translatesAutoresizingMaskIntoConstraints = false
        return imageview
    }()
    
    lazy var VehicleInfoText: UILabel = {
        let text = UILabel()
        text.layout(colour: .black, size: 18, text: "", bold: true)
        text.lineBreakMode = .byWordWrapping
        text.numberOfLines = 0
        return text
    }()
    
    lazy var NumberPlateText: UILabel = {
        let text = UILabel()
        text.layout(colour: .black, size: 16, text: "", bold: true)
        text.backgroundColor = numberplatecolour
        text.textAlignment = .center
        text.layer.cornerRadius = 4
        text.layer.masksToBounds = true
        return text
    }()
    
    lazy var MOTTitle: UILabel = {
        let text = UILabel()
        text.layout(colour: .black, size: 20, text: "My MOT's", bold: true)
        return text
    }()
    
    lazy var MOTCollectionView: SelfSizedCollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionview = SelfSizedCollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionview.register(MOTCell.self, forCellWithReuseIdentifier: "motCell")
        collectionview.delegate = self
        collectionview.dataSource = self
        collectionview.backgroundColor = .clear
        collectionview.layer.cornerRadius = 0
        collectionview.layer.masksToBounds = true
        collectionview.isScrollEnabled = true
        collectionview.showsHorizontalScrollIndicator = false
        return collectionview
    }()
    
    
    let yearlabel = homepageiconbutton.setimageandtext(image: "clock.arrow.circlepath", text: "")
    let fuellabel = homepageiconbutton.setimageandtext(image: "fuelpump", text: "")
    let emissionslabel = homepageiconbutton.setimageandtext(image: "leaf", text: "")
    
    let dropDown = DropDown()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hexString: "FDFDFD")//.white
        setupView()
        navigationController?.isNavigationBarHidden = false
        isLoggedIn()
        setupnavbar()
        getcarlist()
        setupDropdown()
        let dummydata = MOTData(dictionary: [:])
        MOTdata.insert(dummydata, at: 0)
 
        }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getuserCarData()
    }
    
    func setupDropdown() {
        dropDown.anchorView = numberplatedropdownbutton
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
          print("Selected item: \(item) at index: \(index)")
            selectcar(numberplate: item)
            getMOTDataforCar(car: item)
        }
    }
    
    func selectcar(numberplate:String) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        let ref = Firestore.firestore().collection("users").document(uid)
            ref.setData(["selectedCar":numberplate], merge: true) { error in
                if error != nil {
                    print(error!.localizedDescription)
            }
                self.getuserCarData()
        }
    }

    
    func setupnavbar() {
        
       // let mygaragesbutton = UIBarButtonItem.init(customView: mygaragesButton)
        
        numberplatedropdownbutton.addTarget(self, action: #selector(showdropdown), for: .touchUpInside)
        
        self.navigationItem.titleView = numberplatedropdownbutton
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear.circle")?.withTintColor(.black).withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(handleLogout))
        
    }
    
    @objc func showdropdown() {
        dropDown.show()
    }
    
    func isLoggedIn() {
        if Auth.auth().currentUser == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        }
        else {
           //load the pictures
            
        }
    }
    

    @objc func handleLogout() {
        
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print("logout error", logoutError)
        }
        
        let landingpage = OnboardingPage()
        let nav = UINavigationController(rootViewController: landingpage)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: false)
    }
    
    @objc func gotoMotbooking() {
        let motbooking = ShowBookings()
        navigationController?.pushViewController(motbooking, animated: true)
    }
    
    func setupView() {
        //view.addSubview(mygaragesButton)
        view.addSubview(CoastTitle)
        view.addSubview(LogoImage)
        view.addSubview(MyCarText)
        view.addSubview(CarContainerView)
        view.addSubview(welcomebackText)
        view.addSubview(MOTTitle)
        view.addSubview(MOTCollectionView)
        
        CarContainerView.addSubview(MyVehicleText)
        CarContainerView.addSubview(CarImage)
        CarContainerView.addSubview(VehicleInfoText)
        CarContainerView.addSubview(yearlabel)
        CarContainerView.addSubview(fuellabel)
        CarContainerView.addSubview(emissionslabel)
        
        CarContainerView.addSubview(NumberPlateText)

        CoastTitle.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 10, bottom: nil, paddingBottom: 0, left: view.leftAnchor, paddingLeft: 30, right: nil, paddingRight: 0, width: 0, height: 0)
        
        LogoImage.anchor(top: nil, paddingTop: 10, bottom: nil, paddingBottom: 0, left: CoastTitle.rightAnchor, paddingLeft: 8, right: nil, paddingRight: 0, width: 25, height: 25)
        LogoImage.centerYAnchor.constraint(equalTo: CoastTitle.centerYAnchor).isActive = true
        
        welcomebackText.anchor(top: CoastTitle.bottomAnchor, paddingTop: 5, bottom: nil, paddingBottom: 0, left: view.leftAnchor, paddingLeft: 30, right: nil, paddingRight: 0, width: 0, height: 0)
        
        MyCarText.anchor(top: welcomebackText.bottomAnchor, paddingTop: 20, bottom: nil, paddingBottom: 0, left: view.leftAnchor, paddingLeft: 30, right: nil, paddingRight: 0, width: 0, height: 0)
        
        CarContainerView.anchor(top: MyCarText.bottomAnchor, paddingTop: 20, bottom: nil, paddingBottom: 0, left: nil, paddingLeft: 0, right: nil, paddingRight: 0, width: 0, height: 0)
        CarContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        CarContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        CarContainerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3).isActive = true
        
        
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        //CarContainerView
        
        MyVehicleText.anchor(top: CarContainerView.topAnchor, paddingTop: 20, bottom: nil, paddingBottom: 0, left: CarContainerView.leftAnchor, paddingLeft: 20, right:nil, paddingRight: 0, width: 0, height: 0)
        
        CarImage.anchor(top: MyVehicleText.bottomAnchor, paddingTop: 0, bottom: nil, paddingBottom: 0, left: CarContainerView.leftAnchor, paddingLeft: 10, right:CarContainerView.rightAnchor, paddingRight: 10, width: 0, height: 0)
        CarImage.centerXAnchor.constraint(equalTo: CarContainerView.centerXAnchor).isActive = true
        CarImage.heightAnchor.constraint(equalTo: CarContainerView.heightAnchor, multiplier: 0.55).isActive = true
        
        VehicleInfoText.anchor(top: CarImage.bottomAnchor, paddingTop: 0, bottom: nil, paddingBottom: 0, left: CarContainerView.leftAnchor, paddingLeft: 20, right:nil, paddingRight: 0, width: 0, height: 0)
    
        
        yearlabel.anchor(top: VehicleInfoText.bottomAnchor, paddingTop: 5, bottom: nil, paddingBottom: 0, left: CarContainerView.leftAnchor, paddingLeft: 20, right: nil, paddingRight: 0, width: 0, height: 30)
        
        fuellabel.anchor(top: VehicleInfoText.bottomAnchor, paddingTop: 5, bottom: nil, paddingBottom: 0, left: yearlabel.rightAnchor, paddingLeft: 10, right: nil, paddingRight: 0, width: 0, height: 30)
        
        emissionslabel.anchor(top: VehicleInfoText.bottomAnchor, paddingTop: 5, bottom: nil, paddingBottom: 0, left: fuellabel.rightAnchor, paddingLeft: 10, right: nil, paddingRight: 0, width: 0, height: 30)
        
        
        NumberPlateText.anchor(top: nil, paddingTop: 0, bottom: nil, paddingBottom: 0, left: VehicleInfoText.rightAnchor, paddingLeft: 0, right:CarContainerView.rightAnchor, paddingRight: 20, width: 0, height: 0)
        NumberPlateText.centerYAnchor.constraint(equalTo: VehicleInfoText.centerYAnchor).isActive = true
        NumberPlateText.heightAnchor.constraint(equalTo: CarContainerView.heightAnchor, multiplier: 0.09).isActive = true
        NumberPlateText.widthAnchor.constraint(equalTo: CarContainerView.widthAnchor, multiplier: 0.3).isActive = true

        MOTTitle.anchor(top: CarContainerView.bottomAnchor, paddingTop: 20, bottom: nil, paddingBottom: 0, left: view.leftAnchor, paddingLeft: 30, right: nil, paddingRight: 0, width: 0, height: 0)
        
        MOTCollectionView.anchor(top: MOTTitle.bottomAnchor, paddingTop: 20, bottom: nil, paddingBottom: 0, left: view.leftAnchor, paddingLeft: 20, right: view.rightAnchor, paddingRight: 20, width: 0, height: 150)
        //MOTCollectionView.heightAnchor.constraint(equalTo: view.heightAnchor,multiplier: 0.2).isActive = true
        
    }

}

extension MainPage {
    
    func getMOTDataforCar(car: String) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        let MOTref = Firestore.firestore().collection("users").document(uid).collection("cars").document(car).collection("MOTData").order(by: "TestDate", descending: true)
        MOTref.getDocuments { snapshot, error in
        if error != nil {
            self.Alert(error!.localizedDescription)
        }
        guard let documents = snapshot?.documents else {return}
        self.MOTdata.removeAll()
        for document in documents {
            let data = document.data()
            let mot = MOTData(dictionary: data)
            self.MOTdata.append(mot)
            DispatchQueue.main.async {
                self.MOTCollectionView.reloadData()
                }
            }
        }
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
    
    
    func getselectedcar(completion: @escaping (String) -> Void) {
        if let uid = Auth.auth().currentUser?.uid {
        
        let selectedcarref = Firestore.firestore().collection("users").document(uid)
        selectedcarref.getDocument { document, error in
            
            if error != nil {
                self.Alert(error!.localizedDescription)
            }
            let data = document?.data()
            if let selectedcar = data?["selectedCar"] as? String {
                self.getMOTDataforCar(car: selectedcar)
                completion(selectedcar)
                }
            }
        }
    }
    
    func getuserCarData() {
        getselectedcar { selectedcar in
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        let ref = Firestore.firestore().collection("users").document(uid).collection("cars").document(selectedcar)
        ref.getDocument { document, error in
            
            if error != nil {
                self.Alert(error!.localizedDescription)
            }

            guard let data = document?.data() else {return}
            let car = FirebaseCarData(dictionary: data)
            guard let CO2Emissions = car.CO2Emissions else {return}
            guard let Colour = car.Colour else {return}
            guard let Year = car.Year else {return}
            guard let Fuel = car.Fuel else {return}
            guard let Make = car.Make else {return}
            guard let Model = car.Model else {return}
            guard var Registration = car.Registration else {return}
            guard let MotDate = car.MotDate else {return}
            guard let MotDateString = car.MotDateString else {return}
            guard let ValidMot = car.ValidMot else {return}
            guard let imageurl = car.imageurl else {return}
            
            let make = Make.lowercased().capitalizingFirstLetter()
            let model = Model.lowercased().capitalizingFirstLetter()
            
            self.VehicleInfoText.text = "\(make) \(model)"
            
            self.numberplatedropdownbutton.setTitle("  \(Registration)  ↓", for: .normal)
            
            //set car image
            if let url = URL(string: imageurl) {
                Nuke.loadImage(with: url, into: self.CarImage)
            }
                

            //guard let todaysDate = self.getTodaysDate().toDate() else {return}
            
            //self.MOTTextDetails.text = "\(MotDateString)"
                
            Registration.insert(" ", at: Registration.index(Registration.startIndex, offsetBy: 4))
            self.NumberPlateText.text = Registration
                
                let fuel = Fuel.lowercased().capitalizingFirstLetter()

                self.yearlabel.setTitle(" \(Year)", for: .normal)
                self.fuellabel.setTitle(" \(fuel)", for: .normal)
                self.emissionslabel.setTitle(" \(CO2Emissions)", for: .normal)
                
                self.MotDate = MotDateString
            
//            if todaysDate > MotDate {
//                print("mot due")
//                self.MOTContainerView.backgroundColor = .red
//                self.MOTCheck.backgroundColor = .white
//                self.MOTCheck.setsizedImage(symbol: "xmark", size: 8, colour: .red)
//                self.MOTTextDetails.text = "Your MOT is due\nBook an MOT below"
//                }
                    
                }
            }
        }
    }


extension MainPage: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
        
        
   func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return MOTdata.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "motCell", for: indexPath) as! MOTCell
        
        if indexPath.item == 0 {
            cell.backgroundColor = UIColor(hexString: "222222")
            cell.layer.cornerRadius = 15
            cell.layer.masksToBounds = true
            cell.datelabel.textColor = .white
            cell.odometerlabel.textColor = .white
            cell.MOTImage.image = UIImage(named: "MOT")?.withTintColor(.white).withRenderingMode(.alwaysOriginal)
            cell.datelabel.text = "MOT"
            cell.odometerlabel.font = UIFont.systemFont(ofSize: 12)
            cell.odometerlabel.text = self.MotDate
        }
        else {
            print(indexPath.item)
            let car = MOTdata[indexPath.item]
            cell.layer.cornerRadius = 15
            cell.layer.masksToBounds = true
            cell.backgroundColor = UIColor(hexString: "F6F6F6")
            
            let dateFormatterGet = DateFormatter()
            dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mmZ"
            
            let dateFormatterPrint = DateFormatter()
            dateFormatterPrint.dateFormat = "MMM d yyyy"
            
            cell.datelabel.textColor = .black
            cell.odometerlabel.textColor = .black
            cell.MOTImage.image = UIImage(named: "MOT")?.withTintColor(.black).withRenderingMode(.alwaysOriginal)
            
            if let testdate = car.TestDate {
                //print(testdate)
            if let date = dateFormatterGet.date(from: testdate) {
                cell.datelabel.text = "\(dateFormatterPrint.string(from: date))"
            } else {
               print("There was an error decoding the string")
            }
        }
            cell.odometerlabel.text = "\(car.Odometer!) \(car.OdometerUnit!)"
        }

        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSize = CGSize(width: 140, height: 150)
        return itemSize // Replace with count of your data for collectionViewA
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 20

    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //let car = MOTdata[indexPath.item]

       
    }

        
    }
