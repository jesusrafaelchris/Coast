//
//  CarCell.swift
//  KeyloopCarApp
//
//  Created by Christian Grinling on 02/02/2022.
//

import UIKit

class CarCell: UICollectionViewCell {
    
    let numberplatecolour = UIColor(hexString: "#F9D349")
    let graycolour = UIColor(hexString: "#393C41")
    
    lazy var CarImage: UIImageView = {
        let imageview = UIImageView()
        imageview.contentMode = .scaleAspectFill
        imageview.layer.masksToBounds = true
        imageview.translatesAutoresizingMaskIntoConstraints = false
        return imageview
    }()
    
    lazy var makeText: UILabel = {
        let text = UILabel()
        text.layout(colour: .black, size: 14, text: "", bold: false)
        //text.backgroundColor = .blue
        return text
    }()
    
    lazy var modelText: UILabel = {
        let text = UILabel()
        text.layout(colour: .black, size: 14, text: "", bold: true)
        //text.backgroundColor = .red
        return text
    }()
    
    lazy var NumberPlateText: UILabel = {
        let text = UILabel()
        text.layout(colour: .black, size: 16, text: "", bold: true)
        text.backgroundColor = numberplatecolour
        text.textAlignment = .center
        text.layer.cornerRadius = 4
        text.layer.masksToBounds = true
        return text
    }()
    
    lazy var carIcon: UIButton = {
        let button = UIButton()
        button.setsizedImage(symbol: "car", size: 14, colour: UIColor(hexString: "222222"))
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
        addSubview(carIcon)
        addSubview(makeText)
        addSubview(modelText)
        addSubview(NumberPlateText)
        addSubview(CarImage)
        
        carIcon.anchor(top: topAnchor, paddingTop: 10, bottom: nil, paddingBottom: 0, left: leftAnchor, paddingLeft: 10, right: nil, paddingRight: 0, width: 40, height: 40)
        
        makeText.anchor(top: topAnchor, paddingTop: 10, bottom: nil, paddingBottom: 0, left: carIcon.rightAnchor, paddingLeft: 10, right: nil, paddingRight: 0, width: 0, height: 25)
        
        modelText.anchor(top: makeText.bottomAnchor, paddingTop: 0, bottom: nil, paddingBottom: 0, left: carIcon.rightAnchor, paddingLeft: 10, right: nil, paddingRight: 0, width: 0, height: 25)
        
        NumberPlateText.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.1).isActive = true
        NumberPlateText.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.27).isActive = true
        NumberPlateText.anchor(top: modelText.bottomAnchor, paddingTop: 20, bottom: nil, paddingBottom: 0, left: leftAnchor, paddingLeft: 10, right: nil, paddingRight: 0, width: 0, height: 0)
        
        CarImage.anchor(top: modelText.bottomAnchor, paddingTop: 5, bottom: bottomAnchor, paddingBottom: 0, left: leftAnchor, paddingLeft: 0, right: nil, paddingRight: 0, width: 0, height: 0)
        CarImage.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1.5).isActive = true
        //CarImage.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1).isActive = true
        
    }
}
