//
//  SignUpPage.swift
//  KeyloopCarApp
//
//  Created by Christian Grinling on 08/11/2021.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseMessaging

class SignUpPage: UIViewController, UITextFieldDelegate, XMLParserDelegate {
    
    let blackbrown = UIColor(hexString: "#1D2128")
    let crimson = UIColor(hexString: "#E7515A")
    
    lazy var CarImage: UIImageView = {
        let imageview = UIImageView()
        imageview.image = UIImage(named: "signupcar.png")
        imageview.contentMode = .scaleAspectFill
        imageview.translatesAutoresizingMaskIntoConstraints = false
        return imageview
    }()
    
    lazy var namefield: UITextField = {
        let textfield = UITextField()
        textfield.delegate = self
        textfield.signuptext(placeholder: "First name", returnkey: .continue, tag: 0, image: "person.fill")
        return textfield
    }()
    
    lazy var emailfield: UITextField = {
        let textfield = UITextField()
        textfield.delegate = self
        textfield.signuptext(placeholder: "Email", returnkey: .continue, tag: 1, image: "envelope.fill")
        return textfield
    }()
    
    lazy var passwordfield: UITextField = {
        let textfield = UITextField()
        textfield.delegate = self
        textfield.signuptext(placeholder: "Password", returnkey: .done, tag: 2, image: "lock.open.fill")
        textfield.isSecureTextEntry = true
        return textfield
    }()
    
    lazy var SignupTitle: UILabel = {
        let text = UILabel()
        text.layout(colour: .black, size: 23, text: "Sign up", bold: true)
        return text
    }()
    
    lazy var signUpButton = darkblackbutton.textstring(text: "Sign Up")

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupView()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismisskeyboard)))
        signUpButton.addTarget(self, action: #selector(signUp), for: .touchUpInside)
    }
    
    @objc func signUp() {
        //show spinner
        self.showSpinner(onView: view)
        
        //define safe textfields
        guard let name = namefield.text else {return}
        guard let email = emailfield.text else {return}
        guard let password = passwordfield.text else {return}
        
        //check if they're empty
        checkIfEmpty(fields: [namefield,emailfield,passwordfield])
        
        //create user
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if error != nil {
                self.AlertofError("Please try again", error!.localizedDescription)
                self.removeSpinner()
                return
            }
            else {
                //add display name
                self.addDisplayName(name: name)
                self.addnotificationtoken()
                self.removeSpinner()
                
                //navigate to enter reg plate
                let enterReg = EnterRegPlate()
                self.navigationController?.pushViewController(enterReg, animated: true)
            }
        }
    }

    func addnotificationtoken() {
      guard let uid = Auth.auth().currentUser?.uid else {return}
      let fcmtoken = Messaging.messaging().fcmToken
      let userDoc = Firestore.firestore().collection("users").document(uid)
      userDoc.setData(["notificationToken":fcmtoken], merge: true)
        
    }

    
    @objc func dismisskeyboard() {
        //when the view is pressed dismiss all keyboards
        namefield.resignFirstResponder()
        emailfield.resignFirstResponder()
        passwordfield.resignFirstResponder()
    }
    
    override func viewDidLayoutSubviews() {
        //add bottom border to all textfields
        self.namefield.addBottomBorder(colour: blackbrown.cgColor)
        self.emailfield.addBottomBorder(colour: blackbrown.cgColor)
        self.passwordfield.addBottomBorder(colour: blackbrown.cgColor)
    }
    
    func setupView() {
        view.addSubview(CarImage)
        view.addSubview(namefield)
        view.addSubview(emailfield)
        view.addSubview(passwordfield)
        view.addSubview(SignupTitle)
        view.addSubview(signUpButton)
        
        CarImage.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 0, bottom: nil, paddingBottom: 30, left: nil, paddingLeft: 20, right: nil, paddingRight: 20, width: 0, height: 0)
        CarImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            self.CarImage.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.3).isActive = true
        self.CarImage.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.9).isActive = true
        
        
        SignupTitle.anchor(top: CarImage.bottomAnchor, paddingTop: 0, bottom: nil, paddingBottom: 0, left: view.leftAnchor, paddingLeft: 20, right: nil, paddingRight: 40, width: 0, height: 0)
        
        namefield.anchor(top: SignupTitle.bottomAnchor, paddingTop: 30, bottom: nil, paddingBottom: 0, left: nil, paddingLeft: 20, right: nil, paddingRight: 20, width: 0, height: 45)
        namefield.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        namefield.widthAnchor.constraint(equalTo:view.widthAnchor,multiplier: 0.7).isActive = true
        
        emailfield.anchor(top: namefield.bottomAnchor, paddingTop: 30, bottom: nil, paddingBottom: 0, left: nil, paddingLeft: 20, right: nil, paddingRight: 20, width: 0, height: 45)
        emailfield.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emailfield.widthAnchor.constraint(equalTo:view.widthAnchor,multiplier: 0.7).isActive = true
 
        
        passwordfield.anchor(top: emailfield.bottomAnchor, paddingTop: 30, bottom: nil, paddingBottom: 0, left: nil, paddingLeft: 20, right: nil, paddingRight: 20, width: 0, height: 45)
            passwordfield.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        passwordfield.widthAnchor.constraint(equalTo:view.widthAnchor,multiplier: 0.7).isActive = true
        
        
        signUpButton.anchor(top: passwordfield.bottomAnchor, paddingTop: 50, bottom: nil, paddingBottom: 40, left: nil, paddingLeft: 20, right: nil, paddingRight: 20, width: 0, height: 0)
        signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        signUpButton.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.07).isActive = true
        signUpButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.5).isActive = true
    }
    
   
        
}

extension SignUpPage {
    
    //MARK: Actions
    
    //check if empty textfield function
    func checkIfEmpty(fields: [UITextField]) {
        for field in fields {
            if field.text?.isEmpty == true {
                    return self.Alert(field.placeholder!)
                }
            }
        }
    
    //move on to next field when enter key pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       // Try to find next responder
       if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
          nextField.becomeFirstResponder()
       } else {
          // Not found, so remove keyboard.
          textField.resignFirstResponder()
       }
       // Do not add a line break
       return false
    }
    
    //when textfield is selected make the bottom colour line red
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let textfield = view.selectedTextField
        textfield?.addBottomBorder(colour: crimson.cgColor)
        textfield?.layoutSubviews()
    }
    
    //add name as firebase set display name
    func addDisplayName(name: String) {
        let user = Auth.auth().currentUser
        if let user = user {
            let changeRequest = user.createProfileChangeRequest()
            changeRequest.displayName = name
            changeRequest.commitChanges { error in
             if let error = error {print(error.localizedDescription)} else {
               print("Added Display Name")}}}}
    
}


