//
//  FeaturedGarageCell.swift
//  KeyloopCarApp
//
//  Created by Christian Grinling on 19/02/2022.
//

import UIKit

class FeaturedGarageCell: UICollectionViewCell {
    
    
    lazy var GarageImage: UIImageView = {
        let imageview = UIImageView()
        imageview.contentMode = .scaleAspectFill
        imageview.layer.masksToBounds = true
        imageview.translatesAutoresizingMaskIntoConstraints = false
        return imageview
    }()
    
    lazy var GarageName: UILabel = {
        let text = UILabel()
        text.layout(colour: .white, size: 16, text: "Loading..", bold: true)
        return text
    }()
    
    lazy var FarAwayText: UIButton = {
        let button = UIButton()
        button.layout(textcolour: .white, backgroundColour: nil, size: 14, text: "1.3 miles", image: UIImage(systemName: "location.magnifyingglass")?.withTintColor(.white).withRenderingMode(.alwaysOriginal), cornerRadius: 0)
        return button
    }()
    
    lazy var RatingText: UIButton = {
        let button = UIButton()
        button.layout(textcolour: .white, backgroundColour: nil, size: 14, text: "4.8", image: UIImage(systemName: "star.fill")?.withTintColor(.white).withRenderingMode(.alwaysOriginal), cornerRadius: 0)
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
        
        GarageImage.anchor(top: topAnchor, paddingTop: 0, bottom: bottomAnchor, paddingBottom: 0, left: leftAnchor, paddingLeft: 0, right: rightAnchor, paddingRight: 0, width: 0, height: 0)
        
        RatingText.anchor(top: nil, paddingTop: 0, bottom: bottomAnchor, paddingBottom: 10, left: leftAnchor, paddingLeft: 20, right: nil, paddingRight: 0, width: 0, height: 0)
        
        FarAwayText.anchor(top: nil, paddingTop: 0, bottom: bottomAnchor, paddingBottom: 10, left: RatingText.rightAnchor, paddingLeft: 10, right: nil, paddingRight: 0, width: 0, height: 0)
        
        GarageName.anchor(top: nil, paddingTop: 0, bottom: RatingText.topAnchor, paddingBottom: 10, left: leftAnchor, paddingLeft: 20, right: nil, paddingRight: 0, width: 0, height: 0)
    }
}
