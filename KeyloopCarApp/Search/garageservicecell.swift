//
//  garageservicecell.swift
//  KeyloopCarApp
//
//  Created by Christian Grinling on 06/02/2022.
//

import UIKit

class garageservicecell: UICollectionViewCell {
    
    lazy var ServiceImage: UIImageView = {
        let imageview = UIImageView()
        imageview.contentMode = .scaleAspectFit
        imageview.layer.masksToBounds = true
        imageview.translatesAutoresizingMaskIntoConstraints = false
        imageview.layer.cornerRadius = 10
        return imageview
    }()
    
    lazy var ServiceName: UILabel = {
        let text = UILabel()
        text.layout(colour: .black, size: 16, text: "", bold: true)
        return text
    }()
    
    lazy var Pricetext: UILabel = {
        let text = UILabel()
        text.layout(colour: .black, size: 14, text: "", bold: false)
        return text
    }()
    
    lazy var Timetext: UIButton = {
        let button = UIButton()
        button.layout(textcolour: .black, backgroundColour: UIColor(hexString: "EEEEEE"), size: 12, text: "", image: nil, cornerRadius: 15)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        addSubview(ServiceImage)
        addSubview(ServiceName)
        addSubview(Pricetext)
        addSubview(Timetext)
        
        ServiceImage.anchor(top: topAnchor, paddingTop: 0, bottom: bottomAnchor, paddingBottom: 0, left: leftAnchor, paddingLeft: 0, right: nil, paddingRight: 9, width: 0, height: 0)
        ServiceImage.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.2).isActive = true
        
        ServiceName.anchor(top: nil, paddingTop: 0, bottom: centerYAnchor, paddingBottom: 3, left: ServiceImage.rightAnchor, paddingLeft: 10, right: nil, paddingRight: 0, width: 0, height: 0)
        
        Pricetext.anchor(top: ServiceName.bottomAnchor, paddingTop: 5, bottom: nil, paddingBottom: 0, left: ServiceImage.rightAnchor, paddingLeft: 10, right: nil, paddingRight: 0, width: 0, height: 0)
        
        Timetext.anchor(top: nil, paddingTop: 10, bottom: nil, paddingBottom: 0, left: nil, paddingLeft: 10, right: rightAnchor, paddingRight: 30, width: 0, height: 30)
        Timetext.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.2).isActive = true
        Timetext.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
    }
}
