//
//  OnboardingPage.swift
//  KeyloopCarApp
//
//  Created by Christian Grinling on 08/11/2021.
//

import UIKit

class OnboardingPage: UIViewController {
    
    let blackbrown = UIColor(hexString: "#1D2128")
    let crimson = UIColor(hexString: "#E7515A")
    let lightgray = UIColor(hexString: "#A5A3A3")
    let background = UIColor(hexString: "#F7F7F7")
    
    lazy var CarImage: UIImageView = {
        let imageview = UIImageView()
        imageview.image = UIImage(named: "signupcar.png")
        imageview.contentMode = .scaleAspectFit
        imageview.translatesAutoresizingMaskIntoConstraints = false
        return imageview
    }()
    
    lazy var QuestionTitle: UILabel = {
        let text = UILabel()
        text.layout(colour: .black, size: 22, text: "Need an MOT or Service?", bold: true)
        //text.adjustsFontSizeToFitWidth = true
        return text
    }()
    
    lazy var DetailText: UILabel = {
        let text = UILabel()
        text.layout(colour: lightgray, size: 18, text: "Book with Coast now\nand enjoy live tracking updates\nfrom your nearest garage", bold: true)
        text.numberOfLines = 0
        text.textAlignment = .center
        return text
    }()
    
    lazy var signInButton: UIButton = {
        let button = UIButton()
        button.layout(textcolour: .white, backgroundColour: blackbrown, size: 18, text: "Sign in", image: nil, cornerRadius: 15)
        button.isUserInteractionEnabled = true
        return button
    }()
    
    lazy var DontHaveAccount: UILabel = {
        let text = UILabel()
        text.layout(colour: lightgray, size: 14, text: "Don’t have an account?", bold: true)
        return text
    }()
    
    lazy var signupButton: UIButton = {
        let button = UIButton()
        button.contentHorizontalAlignment = .left
        button.layout(textcolour: crimson, backgroundColour: .clear, size: 16, text: "Sign up", image: nil, cornerRadius: 0)
        button.isUserInteractionEnabled = true
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupView()
        signInButton.addTarget(self, action: #selector(goToSignIn), for: .touchUpInside)
        signupButton.addTarget(self, action: #selector(goToSignup), for: .touchUpInside)
    }
    
    @objc func goToSignIn() {
        let signin = SignInPage()
        navigationController?.pushViewController(signin, animated: true)
    }
    
    @objc func goToSignup() {
        let signup = SignUpPage()
        navigationController?.pushViewController(signup, animated: true)
    }
    
    func setupView() {
        view.addSubview(CarImage)
        view.addSubview(QuestionTitle)
        view.addSubview(DetailText)
        view.addSubview(signInButton)
        view.addSubview(DontHaveAccount)
        view.addSubview(signupButton)
        
        CarImage.anchor(top: nil, paddingTop: 0, bottom: view.centerYAnchor, paddingBottom: 0, left: nil, paddingLeft: 20, right: nil, paddingRight: 20, width: 0, height: 0)
        CarImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            self.CarImage.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.4).isActive = true
        self.CarImage.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.9).isActive = true
        
        QuestionTitle.anchor(top: CarImage.bottomAnchor, paddingTop: 0, bottom: nil, paddingBottom: 0, left: nil, paddingLeft: 40, right: nil, paddingRight: 40, width: 0, height: 0)
        QuestionTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        //QuestionTitle.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.7).isActive = true
        
        DetailText.anchor(top: QuestionTitle.bottomAnchor, paddingTop: 50, bottom: nil, paddingBottom: 0, left: nil, paddingLeft: 20, right: nil, paddingRight: 20, width: 0, height: 0)
        DetailText.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        signInButton.anchor(top: nil, paddingTop: 0, bottom: DontHaveAccount.topAnchor, paddingBottom: 40, left: nil, paddingLeft: 20, right: nil, paddingRight: 20, width: 0, height: 0)
        signInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        signInButton.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.07).isActive = true
        signInButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.5).isActive = true
    
        DontHaveAccount.anchor(top: nil, paddingTop: 0, bottom: view.bottomAnchor, paddingBottom: 50, left: nil, paddingLeft: 20, right: nil, paddingRight: 0, width: 0, height: 0)
        DontHaveAccount.centerXAnchor.constraint(equalTo: view.centerXAnchor,constant: -30).isActive = true
        
        signupButton.anchor(top: nil, paddingTop: 0, bottom: DontHaveAccount.bottomAnchor, paddingBottom: 0, left: DontHaveAccount.rightAnchor, paddingLeft: 10, right: nil, paddingRight: 0, width: 100, height: 40)
        signupButton.centerYAnchor.constraint(equalTo: DontHaveAccount.centerYAnchor).isActive = true
        
    }
    
}
