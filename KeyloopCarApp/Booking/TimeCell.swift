//
//  TimeCell.swift
//  KeyloopCarApp
//
//  Created by Christian Grinling on 05/11/2021.
//

import UIKit

class TimeCell: UICollectionViewCell {
    
    
    override var isSelected: Bool{
        willSet{
            super.isSelected = newValue
            if newValue
            {
                self.backgroundColor = .red
                self.TimeText.textColor = .white
            }
            else
            {
                self.backgroundColor = UIColor(hexString: "222222")
                self.TimeText.textColor = .white
            }
        }
    }
    
    lazy var TimeText: UILabel = {
        let label = UILabel()
        label.layout(colour: .white, size: 14, text: "00:00", bold: true)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        addSubview(TimeText)
        
        TimeText.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        TimeText.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
    }
}
