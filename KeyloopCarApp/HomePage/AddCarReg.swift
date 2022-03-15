//
//  AddCarReg.swift
//  KeyloopCarApp
//
//  Created by Christian Grinling on 02/02/2022.
//

import UIKit

class AddCarReg: UIViewController, UITextFieldDelegate {
    
    let blackbrown = UIColor(hexString: "#1D2128")
    let numberplatecolour = UIColor(hexString: "#F9D349")
    let crimson = UIColor(hexString: "#E7515A")
    
    lazy var enterRegTitle: UILabel = {
        let label = UILabel()
        label.layout(colour: UIColor(hexString: "222222"), size: 20, text: "Enter your registration plate", bold: true)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    lazy var NumberPlateField: UITextField = {
        let textfield = UITextField()
        textfield.layout(placeholder: "ENTER REG", backgroundcolour: numberplatecolour, bordercolour: .clear, borderWidth: 0, cornerRadius: 8)
        textfield.font = UIFont.boldSystemFont(ofSize: 25)
        textfield.textAlignment = .center
        return textfield
    }()
    
    lazy var nextButton = darkblackbutton.textstring(text: "Next")

    override func viewDidLoad() {
        super.viewDidLoad()
        NumberPlateField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        view.backgroundColor = .white
        setupView()
        nextButton.addTarget(self, action: #selector(getCarData), for: .touchUpInside)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismisskeyboard)))
    }
    
    @objc func dismisskeyboard() {
        //when the view is pressed dismiss all keyboards
        NumberPlateField.resignFirstResponder()
    }
    
    @objc func getCarData() {
        
        guard let numberplate = NumberPlateField.text else {return}
        
        //check if number plate vaild
        if isnumberPlateValid(numberplate) == false {
            self.AlertofError("Please try again", "Your numberplate was entered incorrectly")
            return
        }
        //get post request for car data and delegate it to the confirm car data controller
        self.showSpinner(onView: view)
        
        getCarDataRequest(numberplate: numberplate) { car in
                DispatchQueue.main.async {
                    self.removeSpinner()
                    // if car is found then send data to check right car viewcontroller and present
                    let confirmCar = AddCarConfirm()
                    confirmCar.car =  car
                    self.navigationController?.pushViewController(confirmCar, animated: true)
                }
            }
        }
    
    func setupView() {
        view.addSubview(enterRegTitle)
        view.addSubview(NumberPlateField)
        view.addSubview(nextButton)
        
        enterRegTitle.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 100, bottom: nil, paddingBottom: 0, left: nil, paddingLeft: 0, right: nil, paddingRight: 0, width: 0, height: 0)
        enterRegTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        NumberPlateField.anchor(top: enterRegTitle.bottomAnchor, paddingTop: 30, bottom: nil, paddingBottom: 0, left: nil, paddingLeft: 5, right: nil, paddingRight: 5, width: 0, height: 0)
        NumberPlateField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        NumberPlateField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        NumberPlateField.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.07).isActive = true
        
        
        nextButton.anchor(top: nil, paddingTop: 0, bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 40, left: nil, paddingLeft: 0, right: nil, paddingRight: 0, width: 0, height: 0)
        nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nextButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6).isActive = true
        nextButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.06).isActive = true
    }
    
}

extension AddCarReg {
    
    //MARK: Checks
    
    @objc func textFieldDidChange() {
        NumberPlateField.text = NumberPlateField.text?.uppercased()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == NumberPlateField && (string == " ") {
            return false
        }
        return true
    }
    
    func isnumberPlateValid(_ numberplate: String) -> Bool {
        let numberplateTest = NSPredicate(format: "SELF MATCHES %@",     "(?<Current>^[A-Z]{2}[0-9]{2}[A-Z]{3}$)|(?<Prefix>^[A-Z][0-9]{1,3}[A-Z]{3}$)|(?<Suffix>^[A-Z]{3}[0-9]{1,3}[A-Z]$)|(?<DatelessLongNumberPrefix>^[0-9]{1,4}[A-Z]{1,2}$)|(?<DatelessShortNumberPrefix>^[0-9]{1,3}[A-Z]{1,3}$)|(?<DatelessLongNumberSuffix>^[A-Z]{1,2}[0-9]{1,4}$)|(?<DatelessShortNumberSufix>^[A-Z]{1,3}[0-9]{1,3}$)|(?<DatelessNorthernIreland>^[A-Z]{1,3}[0-9]{1,4}$)|(?<DiplomaticPlate>^[0-9]{3}[DX]{1}[0-9]{3}$)")
        return numberplateTest.evaluate(with: numberplate)
    }
}

extension AddCarReg {
    
//MARK: JSON REQUEST
func getCarDataRequest(numberplate:String,completion: @escaping (CarInfo) -> Void) {

    let url = URL(string: "https://api.vehiclesmart.com/rest/vehicleData?reg=\(numberplate)&appid=coast-GJrN49fHewfh")
    guard let requestUrl = url else { fatalError() }
    // Prepare URL Request Object
    var request = URLRequest(url: requestUrl)
    request.httpMethod = "GET"
                         
    // Perform HTTP Request
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            // Check for Error
            if let error = error {
                print("Error took place \(error)")
                return
            }
            // Convert HTTP Response Data to a String
            if let data = data {
                do {
                    let carjson = try JSONDecoder().decode(CarInfo.self, from: data)
                    completion(carjson)
                } catch {print(String(describing: error))}
            }
        }
    task.resume()
    }
}

