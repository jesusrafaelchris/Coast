//
//  serviceCell.swift
//  KeyloopCarApp
//
//  Created by Christian Grinling on 11/11/2021.
//

import UIKit

class serviceCell: UICollectionViewCell {
    
    let blackbrown = UIColor(hexString: "#1D2128")
    let numberplatecolour = UIColor(hexString: "#F9D349")
    let lightgrey = UIColor(hexString: "#F6F6F6")
    
    override var isSelected: Bool{
        willSet{
            super.isSelected = newValue
            if newValue
            {
                self.layer.borderColor = self.blackbrown.cgColor
                self.layer.borderWidth = 1
                self.ServiceText.textColor = UIColor.black
            }
            else
            {
                self.layer.borderColor = nil
                self.layer.borderWidth = 0
                self.ServiceText.textColor = UIColor.black
            }
        }
    }
    
    lazy var ServiceImage: UIImageView = {
        let imageview = UIImageView()
        imageview.contentMode = .scaleAspectFit
        imageview.translatesAutoresizingMaskIntoConstraints = false
        return imageview
    }()
    
    lazy var ServiceText: UILabel = {
        let text = UILabel()
        text.layout(colour: .black, size: 12, text: "", bold: true)
        text.adjustsFontSizeToFitWidth = true
        text.textAlignment = .center
        text.translatesAutoresizingMaskIntoConstraints = false
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
        addSubview(ServiceImage)
        addSubview(ServiceText)
        
        ServiceImage.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        ServiceImage.centerYAnchor.constraint(equalTo: centerYAnchor,constant: -10).isActive = true
        ServiceImage.heightAnchor.constraint(equalTo: heightAnchor,multiplier: 0.4).isActive = true
        ServiceImage.widthAnchor.constraint(equalTo: widthAnchor,multiplier: 0.8).isActive = true
        
        ServiceText.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        ServiceText.topAnchor.constraint(equalTo: ServiceImage.bottomAnchor,constant: 10).isActive = true
        ServiceText.widthAnchor.constraint(equalTo: widthAnchor,multiplier: 0.8).isActive = true
        
    }
}
