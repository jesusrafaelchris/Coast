//
//  reviewViewController.swift
//  KeyloopCarApp
//
//  Created by Christian Grinling on 07/03/2022.
//

import UIKit
import Nuke
import Firebase
import FirebaseAuth
import FirebaseFirestore

class reviewViewController: UIViewController {
    
    var service: String?
    var garage: String?
    var garageimage: String?
    var id: String?
    
    lazy var GarageImage: UIImageView = {
        let imageview = UIImageView()
        imageview.contentMode = .scaleAspectFill
        imageview.layer.masksToBounds = true
        imageview.translatesAutoresizingMaskIntoConstraints = false
        return imageview
    }()
    
    lazy var ReviewText: UILabel = {
        let text = UILabel()
        if let service = service {
            if let garage = garage {
                text.layout(colour: .black, size: 20, text: "Review your \(service) at \n\(garage)", bold: true)
            }
        }
        text.numberOfLines = 0
        return text
    }()
    
    let star1 = imagebutton.setimageandtag(image: "star", size: 30, colour: .black, tag: 0)
    let star2 = imagebutton.setimageandtag(image: "star", size: 30, colour: .black, tag: 1)
    let star3 = imagebutton.setimageandtag(image: "star", size: 30, colour: .black, tag: 2)
    let star4 = imagebutton.setimageandtag(image: "star", size: 30, colour: .black, tag: 3)
    let star5 = imagebutton.setimageandtag(image: "star", size: 30, colour: .black, tag: 4)
    
    let starStack: equalStackView = {
        let stack = equalStackView()
        stack.layout(axis: .horizontal, distribution: .fillEqually, alignment: .center, spacing: 10)
        return stack
    }()
    
    lazy var Donebutton = darkblackbutton.textstring(text: "Done")

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        if let garageimage = self.garageimage {
            if let url = URL(string: garageimage) {
                Nuke.loadImage(with: url, into: GarageImage)
            }
        }
        setupView()
        addtargets()
    }
    
    func addtargets() {
        star1.addTarget(self, action: #selector(selectstar(_:)), for: .touchUpInside)
        star2.addTarget(self, action: #selector(selectstar(_:)), for: .touchUpInside)
        star3.addTarget(self, action: #selector(selectstar(_:)), for: .touchUpInside)
        star4.addTarget(self, action: #selector(selectstar(_:)), for: .touchUpInside)
        star5.addTarget(self, action: #selector(selectstar(_:)), for: .touchUpInside)
        Donebutton.addTarget(self, action: #selector(done), for: .touchUpInside)
        
    }
    
    @objc func done() {
        guard let id = id else {return}
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let trackingref = Firestore.firestore().collection("userbookings").document(id)
        let userbookingref = Firestore.firestore().collection("users").document(uid).collection("Bookings").document(id)
        
        trackingref.setData(["reviewed":true],merge: true)
        userbookingref.setData(["reviewed":true],merge: true) { error in
            self.dismiss(animated: true)
        }
    }
    
    @objc func selectstar(_ sender: imagebutton) {
        switch sender.tag {
        case 0:
            star1.setsizedImage(symbol: "star.fill", size: 30, colour: .black)
            
        case 1:
            star1.setsizedImage(symbol: "star.fill", size: 30, colour: .black)
            star2.setsizedImage(symbol: "star.fill", size: 30, colour: .black)
            
        case 2:
            star1.setsizedImage(symbol: "star.fill", size: 30, colour: .black)
            star2.setsizedImage(symbol: "star.fill", size: 30, colour: .black)
            star3.setsizedImage(symbol: "star.fill", size: 30, colour: .black)
            
        case 3:
            star1.setsizedImage(symbol: "star.fill", size: 30, colour: .black)
            star2.setsizedImage(symbol: "star.fill", size: 30, colour: .black)
            star3.setsizedImage(symbol: "star.fill", size: 30, colour: .black)
            star4.setsizedImage(symbol: "star.fill", size: 30, colour: .black)
            
        case 4:
            star1.setsizedImage(symbol: "star.fill", size: 30, colour: .black)
            star2.setsizedImage(symbol: "star.fill", size: 30, colour: .black)
            star3.setsizedImage(symbol: "star.fill", size: 30, colour: .black)
            star4.setsizedImage(symbol: "star.fill", size: 30, colour: .black)
            star5.setsizedImage(symbol: "star.fill", size: 30, colour: .black)
            
        default:
            print("default")
        }
    }
    
    func setupView() {
        view.addSubview(GarageImage)
        view.addSubview(ReviewText)
        view.addSubview(starStack)
        
        starStack.addArrangedSubview(star1)
        starStack.addArrangedSubview(star2)
        starStack.addArrangedSubview(star3)
        starStack.addArrangedSubview(star4)
        starStack.addArrangedSubview(star5)
        
        view.addSubview(Donebutton)
        
        GarageImage.anchor(top: view.topAnchor, paddingTop: 0, bottom: nil, paddingBottom: 0, left: view.leftAnchor, paddingLeft: 0, right: view.rightAnchor, paddingRight: 0, width: 0, height: 0)
        GarageImage.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3).isActive = true
        
        ReviewText.anchor(top: GarageImage.bottomAnchor, paddingTop: 20, bottom: nil, paddingBottom: 0, left: view.leftAnchor, paddingLeft: 20, right: nil, paddingRight: 0, width: 0, height: 0)
        
        starStack.anchor(top: ReviewText.bottomAnchor, paddingTop: 30, bottom: nil, paddingBottom: 0, left: view.leftAnchor, paddingLeft: 50, right: view.rightAnchor, paddingRight: 50, width: 0, height: 0)
        
        Donebutton.anchor(top: nil, paddingTop: 20, bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 30, left: nil, paddingLeft: 0, right: nil, paddingRight: 0, width: 0, height: 0)
        Donebutton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        Donebutton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        Donebutton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1).isActive = true
    }

}
