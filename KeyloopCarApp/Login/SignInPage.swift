//
//  SignInPage.swift
//  KeyloopCarApp
//
//  Created by Christian Grinling on 08/11/2021.
//

import UIKit
import Firebase

class SignInPage: UIViewController, UITextFieldDelegate {
    
    let blackbrown = UIColor(hexString: "#1D2128")
    let crimson = UIColor(hexString: "#E7515A")
    
    lazy var CarImage: UIImageView = {
        let imageview = UIImageView()
        imageview.image = UIImage(named: "signupcar.png")
        imageview.contentMode = .scaleAspectFill
        imageview.translatesAutoresizingMaskIntoConstraints = false
        return imageview
    }()
    
    lazy var emailfield: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Email"
        textfield.returnKeyType = .continue
        textfield.delegate = self
        textfield.autocorrectionType = .no
        textfield.autocapitalizationType = .none
        textfield.spellCheckingType = .no
        textfield.addImage(image: "envelope.fill", size: 10, colour: .black, weight: .bold, scale: .medium, padding: 40)
        textfield.tag = 1
        return textfield
    }()
    
    lazy var passwordfield: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Password"
        textfield.autocorrectionType = .no
        textfield.autocapitalizationType = .none
        textfield.spellCheckingType = .no
        textfield.addImage(image: "lock.open.fill", size: 10, colour: .black, weight: .bold, scale: .medium, padding: 40)
        textfield.isSecureTextEntry = true
        textfield.returnKeyType = .done
        textfield.delegate = self
        textfield.tag = 2
        return textfield
    }()
    
    lazy var welcomebackTitle: UILabel = {
        let text = UILabel()
        text.layout(colour: .black, size: 23, text: "Welcome Back", bold: true)
        return text
    }()
    
    lazy var signInButton: UIButton = {
        let button = UIButton()
        button.layout(textcolour: .white, backgroundColour: blackbrown, size: 18, text: "Sign in", image: nil, cornerRadius: 25)
        button.isUserInteractionEnabled = true
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupView()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismisskeyboard)))
        signInButton.addTarget(self, action: #selector(signIn), for: .touchUpInside)
    }
    
    @objc func signIn() {
        self.showSpinner(onView: view)
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        guard let email = emailfield.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {return}
        guard let password = passwordfield.text else {return}
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            
            if error != nil  {
                self.AlertofError("Error", error!.localizedDescription)
                self.removeSpinner()
                return
            }
            else {
                self.removeSpinner()
                let user = result?.user
                print("logged in \(user)")
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @objc func dismisskeyboard() {
        emailfield.resignFirstResponder()
        passwordfield.resignFirstResponder()
    }
    
    override func viewDidLayoutSubviews() {
        self.emailfield.addBottomBorder(colour: blackbrown.cgColor)
        self.passwordfield.addBottomBorder(colour: blackbrown.cgColor)
    }
    
    func setupView() {
        view.addSubview(CarImage)
        view.addSubview(emailfield)
        view.addSubview(passwordfield)
        view.addSubview(welcomebackTitle)
        view.addSubview(signInButton)
        
        CarImage.anchor(top: nil, paddingTop: 0, bottom: view.centerYAnchor, paddingBottom: 30, left: nil, paddingLeft: 20, right: nil, paddingRight: 20, width: 0, height: 0)
        CarImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            self.CarImage.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.3).isActive = true
        self.CarImage.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.9).isActive = true
        
        
        welcomebackTitle.anchor(top: CarImage.bottomAnchor, paddingTop: 0, bottom: nil, paddingBottom: 0, left: view.leftAnchor, paddingLeft: 20, right: nil, paddingRight: 40, width: 0, height: 0)
        
        emailfield.anchor(top: welcomebackTitle.bottomAnchor, paddingTop: 30, bottom: nil, paddingBottom: 0, left: nil, paddingLeft: 20, right: nil, paddingRight: 20, width: 0, height: 45)
        emailfield.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emailfield.widthAnchor.constraint(equalTo:view.widthAnchor,multiplier: 0.7).isActive = true
 
        
        passwordfield.anchor(top: emailfield.bottomAnchor, paddingTop: 30, bottom: nil, paddingBottom: 0, left: nil, paddingLeft: 20, right: nil, paddingRight: 20, width: 0, height: 45)
            passwordfield.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        passwordfield.widthAnchor.constraint(equalTo:view.widthAnchor,multiplier: 0.7).isActive = true
        
        signInButton.anchor(top: passwordfield.bottomAnchor, paddingTop: 60, bottom: nil, paddingBottom: 40, left: nil, paddingLeft: 20, right: nil, paddingRight: 20, width: 0, height: 0)
        signInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        signInButton.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.07).isActive = true
        signInButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.5).isActive = true
    }
    
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let textfield = view.selectedTextField
        textfield?.addBottomBorder(colour: crimson.cgColor)
        textfield?.layoutSubviews()
    }
}
