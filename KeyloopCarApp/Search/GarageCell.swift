//
//  GarageCell.swift
//  KeyloopCarApp
//
//  Created by Christian Grinling on 03/02/2022.
//

import UIKit

class GarageCell: UICollectionViewCell {
    
    lazy var GarageImage: UIImageView = {
        let imageview = UIImageView()
        imageview.contentMode = .scaleAspectFill
        imageview.layer.masksToBounds = true
        imageview.translatesAutoresizingMaskIntoConstraints = false
        imageview.layer.cornerRadius = 10
        imageview.layer.masksToBounds = true
        return imageview
    }()
    
    lazy var GarageName: UILabel = {
        let text = UILabel()
        text.layout(colour: .black, size: 16, text: "", bold: true)
        return text
    }()
    
    lazy var FarAwayText: UIButton = {
        let button = UIButton()
        button.layout(textcolour: .black, backgroundColour: nil, size: 14, text: "1.3 miles", image: UIImage(systemName: "location.magnifyingglass")?.withTintColor(.black).withRenderingMode(.alwaysOriginal), cornerRadius: 0)
        return button
    }()
    
    lazy var RatingText: UIButton = {
        let button = UIButton()
        button.layout(textcolour: .black, backgroundColour: nil, size: 14, text: "", image: UIImage(systemName: "star.fill")?.withTintColor(.black).withRenderingMode(.alwaysOriginal), cornerRadius: 0)
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
        addSubview(GarageImage)
        addSubview(GarageName)
        addSubview(FarAwayText)
        addSubview(RatingText)
        
        GarageImage.anchor(top: topAnchor, paddingTop: 0, bottom: bottomAnchor, paddingBottom: 0, left: leftAnchor, paddingLeft: 5, right: nil, paddingRight: 0, width: 0, height: 0)
        GarageImage.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.2).isActive = true
        
        GarageName.anchor(top: topAnchor, paddingTop: 10, bottom: nil, paddingBottom: 0, left: GarageImage.rightAnchor, paddingLeft: 10, right: nil, paddingRight: 0, width: 0, height: 0)
        
        
//        GarageImage.anchor(top: topAnchor, paddingTop: 0, bottom: nil, paddingBottom: 0, left: leftAnchor, paddingLeft: 0, right: rightAnchor, paddingRight: 0, width: 0, height: 0)
//        GarageImage.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.7).isActive = true
//
//        GarageName.anchor(top: GarageImage.bottomAnchor, paddingTop: 10, bottom: nil, paddingBottom: 0, left: leftAnchor, paddingLeft: 0, right: nil, paddingRight: 0, width: 0, height: 0)
//        GarageName.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8).isActive = true
        
        RatingText.anchor(top: GarageName.bottomAnchor, paddingTop: 5, bottom: nil, paddingBottom: 0, left: GarageImage.rightAnchor, paddingLeft: 10, right: nil, paddingRight: 0, width: 0, height: 0)
        //FarAwayText.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8).isActive = true
        
        FarAwayText.anchor(top: nil, paddingTop: 0, bottom: nil, paddingBottom: 0, left: RatingText.rightAnchor, paddingLeft: 10, right: nil, paddingRight: 20, width: 0, height: 0)
        FarAwayText.centerYAnchor.constraint(equalTo: RatingText.centerYAnchor).isActive = true
    }
}
