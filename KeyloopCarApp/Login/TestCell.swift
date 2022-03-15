//
//  TestCell.swift
//  KeyloopCarApp
//
//  Created by Christian Grinling on 11/11/2021.
//

import UIKit

class TestCell: UICollectionViewCell {
    
    lazy var CarImage: UIImageView = {
        let imageview = UIImageView()
        imageview.contentMode = .scaleAspectFit
        imageview.translatesAutoresizingMaskIntoConstraints = false
        return imageview
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(CarImage)
        CarImage.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        CarImage.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        CarImage.widthAnchor.constraint(equalTo: widthAnchor,multiplier: 0.8).isActive = true
        CarImage.heightAnchor.constraint(equalTo: heightAnchor,multiplier: 0.8).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
