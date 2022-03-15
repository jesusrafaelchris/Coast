//
//  CheckRightCarPage.swift
//  KeyloopCarApp
//
//  Created by Christian Grinling on 09/11/2021.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class ConfirmCar: UIViewController {
    
    var car: CarInfo?
    
    lazy var CheckDetails: UILabel = {
        let text = UILabel()
        text.layout(colour: .black, size: 23, text: "Is this your car?", bold: true)
        return text
    }()
    
    lazy var Make = ConfirmedLabel.confirmtext(textlabel: "Make:", size: 16)
    lazy var makeText = ConfirmedCarText.text(textlabel: "")
    lazy var Colour = ConfirmedLabel.confirmtext(textlabel: "Colour:", size: 16)
    lazy var ColourText = ConfirmedCarText.text(textlabel: "")
    
    lazy var containerview = ContainerView.layout(colour: UIColor(hexString: "222222"), cornerradius: 20)
    
    lazy var makestackView: UIStackView = {
        let stack = equalStackView()
        stack.layout(axis: .horizontal, distribution: .fill, alignment: .center, spacing: 0)
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    lazy var colourstackView: UIStackView = {
        let stack = equalStackView()
        stack.layout(axis: .horizontal, distribution: .fill, alignment: .center, spacing: 0)
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    lazy var yesbutton: UIButton = {
        let button = UIButton()
        button.layout(textcolour: .black, backgroundColour: .clear, size: 16, text: "Yes", image: UIImage(systemName: "circle"), cornerRadius: 0)
        button.centerTextAndImage(spacing: 10)
        return button
    }()
    
    lazy var nobutton: UIButton = {
        let button = UIButton()
        button.layout(textcolour: .black, backgroundColour: .clear, size: 16, text: "No", image: UIImage(systemName: "circle"), cornerRadius: 0)
        button.centerTextAndImage(spacing: 10)
        return button
    }()
    
    lazy var choicestackView: UIStackView = {
        let stack = equalStackView()
        stack.layout(axis: .horizontal, distribution: .fillProportionally, alignment: .center, spacing: 50)
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupView()
        nobutton.addTarget(self, action: #selector(dismissview), for: .touchUpInside)
        yesbutton.addTarget(self, action: #selector(signup), for: .touchUpInside)
        getConfirmedDetails()
    }
    
    func getConfirmedDetails() {
        guard let cardetails = car?.VehicleDetails else {return}
        guard let make = cardetails.Make else {return}
        guard let model = cardetails.Model else {return}
        guard let colour = cardetails.Colour else {return}
        
        DispatchQueue.main.async {
            self.makeText.text = "\(make) \(model)"
            self.ColourText.text = colour
        }
    }
    
    @objc func dismissview() {
        DispatchQueue.main.async {
            self.nobutton.layout(textcolour: .white, backgroundColour: .clear, size: 16, text: "No", image: UIImage(systemName: "circle.fill"), cornerRadius: 0)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func signup() {
        DispatchQueue.main.async {
            self.yesbutton.layout(textcolour: .white, backgroundColour: .clear, size: 16, text: "Yes", image: UIImage(systemName: "circle.fill"), cornerRadius: 0)
        }
        
        //upload all data
        uploadCarData()
        
    }
    
 
    //MARK: SETUP VIEW CONSTRAINTS
    
    func setupView() {
        view.addSubview(CheckDetails)
        view.addSubview(containerview)
        containerview.addSubview(makestackView)
        containerview.addSubview(colourstackView)
        
        makestackView.addArrangedSubview(Make)
        makestackView.addArrangedSubview(makeText)
        
        colourstackView.addArrangedSubview(Colour)
        colourstackView.addArrangedSubview(ColourText)
        
        view.addSubview(choicestackView)
        choicestackView.addArrangedSubview(yesbutton)
        choicestackView.addArrangedSubview(nobutton)
        
        
        CheckDetails.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 100, bottom: nil, paddingBottom: 0, left: nil, paddingLeft: 20, right: nil, paddingRight: 0, width: 0, height: 0)
        CheckDetails.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        containerview.anchor(top: CheckDetails.bottomAnchor, paddingTop: 30, bottom: nil, paddingBottom: 0, left: view.leftAnchor, paddingLeft: 20, right: view.rightAnchor, paddingRight: 20, width: 0, height: 0)
        containerview.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.18).isActive = true
        
        makestackView.anchor(top: containerview.topAnchor, paddingTop: 20, bottom: nil, paddingBottom: 0, left: containerview.leftAnchor, paddingLeft: 40, right: containerview.rightAnchor, paddingRight: 40, width: 0, height: 40)
        //makestackView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1).isActive = true
        
        colourstackView.anchor(top: makestackView.bottomAnchor, paddingTop: 20, bottom: nil, paddingBottom: 0, left: containerview.leftAnchor, paddingLeft: 40, right: containerview.rightAnchor, paddingRight: 40, width: 0, height: 40)
        //colourstackView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1).isActive = true
        
        choicestackView.anchor(top: containerview.bottomAnchor, paddingTop: 20, bottom: nil, paddingBottom: 0, left: nil, paddingLeft: 40, right: nil, paddingRight: 40, width: 0, height: 0)
        choicestackView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2).isActive = true
        choicestackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        choicestackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6).isActive = true
        
    }
    

}

//MARK: UPLOAD ALL CAR DATA TO FIREBASE
extension ConfirmCar {
    
    func uploadCarData() {
        //self.showSpinner(onView: view)
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        //declare firestore batch
        let batch = Firestore.firestore().batch()
        
        //organise data
        
        guard let VehicleDetails = car?.VehicleDetails else {return}

        //VehicleDetails
        guard let CO2Emissions = VehicleDetails.CO2Emissions else {return}
        guard let Colour = VehicleDetails.Colour else {return}
        guard let Year = VehicleDetails.Year else {return}
        guard let Fuel = VehicleDetails.Fuel else {return}
        guard let Make = VehicleDetails.Make else {return}
        guard let Model = VehicleDetails.Model else {return}
        guard let Registration = VehicleDetails.Registration else {return}
        
        //calculated mot data
        guard let CalculatedMot = car?.CalculatedMot else {return}
        
        guard let MotDate = CalculatedMot.MotDate else {return}
        guard let MotDateString = CalculatedMot.MotDateString else {return}
        guard let ValidMot = CalculatedMot.ValidMot else {return}
        
        //declare data [String:Any] object for each
        //in users/uid
        let cardata: [String:Any] = ["CO2Emissions":CO2Emissions, "Colour": Colour, "Year":Year, "Fuel":Fuel, "Make":Make, "Model":Model, "Registration":Registration, "MotDate":MotDate, "MotDateString":MotDateString, "ValidMot":ValidMot]
        
        let cardataref = Firestore.firestore().collection("users").document(uid).collection("cars").document(Registration)
        
        batch.setData(cardata, forDocument: cardataref, merge: true)
        
        let selectedcarRef = Firestore.firestore().collection("users").document(uid)
        
        batch.setData(["selectedCar":Registration], forDocument: selectedcarRef, merge: true)
        batch.setData(["currentlocation":"CurrentLocation"], forDocument: selectedcarRef,merge: true)
        
        //vehicle mot data
        
        guard let VehicleMotData = car?.VehicleMotData else {return}
        
        //in /users/uid/mot/MOT
        
        for mot in VehicleMotData {
            guard let TestDate = mot.TestDate else {return}
            guard let OdometerUnit = mot.OdometerUnit else {return}
            guard let Odometer = mot.Odometer else {return}
            guard let AdvisoryNoticeItems = mot.AdvisoryNoticeItems else {return}
            guard let DangerousCount = mot.DangerousCount else {return}
            guard let MajorCount = mot.MajorCount else {return}
            guard let MinorCount = mot.MinorCount else {return}
            guard let ReasonsForFailure = mot.ReasonsForFailure else {return}
            
            let motData: [String:Any] = ["TestDate": TestDate, "OdometerUnit":OdometerUnit, "Odometer":Odometer,"DangerousCount":DangerousCount,"MajorCount":MajorCount,"MinorCount":MinorCount, "AdvisoryNoticeItems":AdvisoryNoticeItems, "ReasonsForFailure":ReasonsForFailure]
            
            let motdataref = Firestore.firestore().collection("users").document(uid).collection("cars").document(Registration).collection("MOTData").document()
            
            batch.setData(motData, forDocument: motdataref, merge: true)
        }
        
        //commit changes
        
        batch.commit { err in
            if let err = err {
                //self.removeSpinner()
                self.AlertofError("Yikes we got an error", err.localizedDescription)
            } else {
                print("Batch write succeeded.")
                //navigate to choose car image view
                //self.removeSpinner()
                let carImage = ChooseCarImage()
                carImage.car =  self.car
                self.navigationController?.pushViewController(carImage, animated: true)
            }
        
        }
    }
    
}

