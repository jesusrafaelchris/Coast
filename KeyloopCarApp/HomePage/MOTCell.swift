//
//  MOTCell.swift
//  KeyloopCarApp
//
//  Created by Christian Grinling on 20/02/2022.
//

import UIKit

class MOTCell: UICollectionViewCell {
    
    lazy var MOTImage: UIImageView = {
        let imageview = UIImageView()
        imageview.contentMode = .scaleAspectFit
        imageview.layer.masksToBounds = true
        imageview.translatesAutoresizingMaskIntoConstraints = false
        imageview.image = UIImage(named: "MOT")?.withTintColor(.black).withRenderingMode(.alwaysOriginal)
       // imageview.backgroundColor = .red
        return imageview
    }()
    
    lazy var datelabel: UILabel = {
        let text = UILabel()
        text.layout(colour: .black, size: 16, text: "", bold: true)
        return text
    }()
    
    lazy var odometerlabel: UILabel = {
        let text = UILabel()
        text.layout(colour: .black, size: 14, text: "", bold: false)
        return text
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var isMOT = false
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func setupView() {
        addSubview(MOTImage)
        addSubview(datelabel)
        addSubview(odometerlabel)
        
        MOTImage.anchor(top: topAnchor, paddingTop: 20, bottom: nil, paddingBottom: 0, left: nil, paddingLeft: 5, right: nil, paddingRight: 5, width: 60, height: 60)
        MOTImage.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        datelabel.anchor(top: MOTImage.bottomAnchor, paddingTop: 0, bottom: nil, paddingBottom: 0, left: nil, paddingLeft: 5, right: nil, paddingRight: 5, width: 0, height: 0)
        datelabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        odometerlabel.anchor(top: datelabel.bottomAnchor, paddingTop: 5, bottom: nil, paddingBottom: 0, left: nil, paddingLeft: 5, right: nil, paddingRight: 5, width: 0, height: 0)
        odometerlabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        
        
        
    }
}
