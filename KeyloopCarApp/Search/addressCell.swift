//
//  addressCell.swift
//  KeyloopCarApp
//
//  Created by Christian Grinling on 10/02/2022.
//

import UIKit
import SwipeCellKit

class addressCell: SwipeCollectionViewCell {
    
    let arrowimage: UIButton = {
        let button = UIButton()
        button.layout(textcolour: nil , backgroundColour: UIColor(hexString: "F6F6F6"), size: nil, text: "", image: UIImage(systemName: "mappin.circle.fill")?.withTintColor(UIColor(hexString: "222222")).withRenderingMode(.alwaysOriginal), cornerRadius: 20)
        return button
    }()
    
    lazy var locationName: UILabel = {
        let text = UILabel()
        text.layout(colour: .black, size: 14, text: "Location", bold: true)
        text.adjustsFontSizeToFitWidth = true
        return text
    }()
    
    lazy var addresslabel: UILabel = {
        let text = UILabel()
        text.layout(colour: .gray, size: 12, text: "Address not Found", bold: false)
        text.adjustsFontSizeToFitWidth = true
        return text
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        addSubview(arrowimage)
        addSubview(locationName)
        addSubview(addresslabel)
        
        
        arrowimage.anchor(top: topAnchor, paddingTop: 10, bottom: nil, paddingBottom: 0, left: leftAnchor, paddingLeft: 20, right: nil, paddingRight: 10, width: 40, height: 40)
        
        locationName.anchor(top: arrowimage.topAnchor, paddingTop: 0, bottom: arrowimage.centerYAnchor, paddingBottom: 0, left: arrowimage.rightAnchor, paddingLeft: 20, right: nil, paddingRight: 10, width: 0, height: 0)
        
        addresslabel.anchor(top: locationName.bottomAnchor, paddingTop: 0, bottom: arrowimage.bottomAnchor, paddingBottom: 0, left: arrowimage.rightAnchor, paddingLeft: 20, right: nil, paddingRight: 10, width: 0, height: 0)
        
    }
}
