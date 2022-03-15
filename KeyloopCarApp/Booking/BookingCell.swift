//
//  BookingCell.swift
//  KeyloopCarApp
//
//  Created by Christian Grinling on 08/11/2021.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import Firebase

class BookingCell: UICollectionViewCell {
    
    let numberplatecolour = UIColor(hexString: "#F9D349")
    
    lazy var ServiceImage: UIImageView = {
        let imageview = UIImageView()
        imageview.contentMode = .scaleAspectFill
        imageview.layer.masksToBounds = true
        imageview.layer.cornerRadius = 10
        imageview.layer.masksToBounds = true
        imageview.translatesAutoresizingMaskIntoConstraints = false
        return imageview
    }()
    
    lazy var GarageName: UILabel = {
        let text = UILabel()
        text.layout(colour: .black, size: 16, text: "", bold: true)
        return text
    }()
    
    lazy var ServiceName: UILabel = {
        let text = UILabel()
        text.layout(colour: .black, size: 14, text: "", bold: false)
        return text
    }()
    
    lazy var checkinbutton = darkblackbutton.textstringsize(text: "Check In", size: 12, cornerRadius: 10)
    
    lazy var trackbutton = darkblackbutton.textstringsize(text: "Track", size: 12, cornerRadius: 10)
    
    var colour = UIColor.black
    
    lazy var Datebutton: UIButton = {
        let button = UIButton()
        button.layout(textcolour: colour, backgroundColour: .clear, size: 12, text: "", image: UIImage(systemName: "calendar")?.withTintColor(colour).withRenderingMode(.alwaysOriginal), cornerRadius: 0)
        return button
    }()
    
    lazy var Timebutton: UIButton = {
        let button = UIButton()
        button.layout(textcolour: colour, backgroundColour: .clear, size: 12, text: "", image: UIImage(systemName: "clock")?.withTintColor(colour).withRenderingMode(.alwaysOriginal), cornerRadius: 0)
        return button
    }()
    
    lazy var Pricebutton: UIButton = {
        let button = UIButton()
        button.layout(textcolour: colour, backgroundColour: .clear, size: 12, text: "", image: UIImage(systemName: "sterlingsign.circle")?.withTintColor(colour).withRenderingMode(.alwaysOriginal), cornerRadius: 0)
        return button
    }()
    
    lazy var ButtonStackView = equalStackView.layoutUIButtons(buttons: [Datebutton,Timebutton,Pricebutton],distribution: .fillEqually)
    
    let radius: CGFloat = 16
    var bookingId: String?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        checkinbutton.isHidden = true
        trackbutton.isHidden = true
        shadowsetup()
    }

    
    func shadowsetup() {
        // Apply rounded corners to contentView
        contentView.layer.cornerRadius = radius
        contentView.layer.masksToBounds = true
        
        // Set masks to bounds to false to avoid the shadow
        // from being clipped to the corner radius
        layer.cornerRadius = radius
        layer.masksToBounds = false
        
        // Apply a shadow
        layer.shadowRadius = 8.0
        layer.shadowOpacity = 0.10
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 5)
        backgroundColor = .white
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Improve scrolling performance with an explicit shadowPath
        layer.shadowPath = UIBezierPath(
            roundedRect: bounds,
            cornerRadius: radius
        ).cgPath
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        addSubview(ServiceImage)
        addSubview(GarageName)
        addSubview(ServiceName)
        addSubview(checkinbutton)
        addSubview(trackbutton)
        addSubview(ButtonStackView)
        
        ServiceImage.anchor(top: nil, paddingTop: 10, bottom: centerYAnchor, paddingBottom: 0, left: leftAnchor, paddingLeft: 10, right: nil, paddingRight: 0, width: 60, height: 60)
        //ServiceImage.widthAnchor.constraint(equalTo: widthAnchor,multiplier: 0.2).isActive = true
        //ServiceImage.heightAnchor.constraint(equalTo: heightAnchor,multiplier: 0.35).isActive = true
        
        GarageName.anchor(top: topAnchor, paddingTop: 30, bottom: nil, paddingBottom: 0, left: ServiceImage.rightAnchor, paddingLeft: 8, right: nil, paddingRight: 0, width: 0, height: 0)
        
        ServiceName.anchor(top: GarageName.bottomAnchor, paddingTop: 5, bottom: nil, paddingBottom: 0, left: ServiceImage.rightAnchor, paddingLeft: 8, right: nil, paddingRight: 0, width: 0, height: 0)
        
        checkinbutton.anchor(top: nil, paddingTop: 10, bottom: nil, paddingBottom: 0, left: nil, paddingLeft: 10, right: rightAnchor, paddingRight: 20, width: 0, height: 0)
        checkinbutton.centerYAnchor.constraint(equalTo: ServiceName.centerYAnchor,constant: 8).isActive = true
        checkinbutton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.18).isActive = true
        checkinbutton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.25).isActive = true
        
        trackbutton.anchor(top: nil, paddingTop: 10, bottom: nil, paddingBottom: 0, left: nil, paddingLeft: 10, right: rightAnchor, paddingRight: 20, width: 0, height: 0)
        trackbutton.centerYAnchor.constraint(equalTo: ServiceName.centerYAnchor,constant: 8).isActive = true
        trackbutton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.18).isActive = true
        trackbutton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.25).isActive = true
        
        
        ButtonStackView.anchor(top: ServiceImage.bottomAnchor, paddingTop: 20, bottom: nil, paddingBottom: 0, left: nil, paddingLeft: 10, right: nil, paddingRight: 0, width: 0, height: 35)
        ButtonStackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        ButtonStackView.widthAnchor.constraint(equalTo: widthAnchor,multiplier: 0.95).isActive = true
        //ButtonStackView.heightAnchor.constraint(equalTo: heightAnchor,multiplier: 0.3).isActive = true
        
        
        
    }
}

