//
//  PullUpView.swift
//  KeyloopCarApp
//
//  Created by Christian Grinling on 06/11/2021.
//

import UIKit

class PullUpView: UIViewController {
    
    var finish: String?
    var garage:String?
    var garageuid: String?
    var completed = false
    
    lazy var estimatedFinish: UILabel = {
        let text = UILabel()
        if completed {
            text.layout(colour: .white, size: 18, text: "Service Finished:", bold: true)
        }
        else {
            text.layout(colour: .white, size: 18, text: "Estimated Finish:", bold: true)
        }
        return text
    }()
    
    lazy var finishTime: UILabel = {
        let text = UILabel()
        if let finish = finish {
            text.layout(colour: .white, size: 18, text: "\(finish) \(addAMorPM(time: finish))", bold: true)
        }
        return text
    }()
    
    lazy var garagename: UILabel = {
        let text = UILabel()
        if let garage = garage {
            text.layout(colour: .white, size: 18, text: garage, bold: true)
        }
        return text
    }()
    
    lazy var textfield: UITextField = {
        let field = UITextField()
        field.layout(placeholder: "  Send Message...", backgroundcolour: .white, bordercolour: .clear, borderWidth: 0, cornerRadius: 15)
        return field
    }()
    
    let phonebutton: UIButton = {
        let button = UIButton()
        button.layout(textcolour: nil , backgroundColour: .white, size: nil, text: "", image: UIImage(systemName: "phone.fill")?.withTintColor(UIColor(hexString: "222222")).withRenderingMode(.alwaysOriginal), cornerRadius: 20)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hexString: "222222")
        setupView()
        textfield.isUserInteractionEnabled = true
        //sendmessagebutton.addTarget(self, action: #selector(openMessageLog), for: .touchUpInside)
        textfield.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openMessageLog)))
    }
    weak var delegate: showMessageDelegate?
    
    @objc func openMessageLog() {
        //self.dismiss

        if let delegate = self.delegate {
            guard let garageuid = garageuid else {return}
            guard let garage = garage else {return}

            delegate.showMessageLog(garageid: garageuid, garagename: garage)
        }
    }
    
    func setupView() {
        view.addSubview(estimatedFinish)
        view.addSubview(finishTime)
        view.addSubview(garagename)
        view.addSubview(textfield)
        view.addSubview(phonebutton)
        
        estimatedFinish.anchor(top: view.topAnchor, paddingTop: 30, bottom: nil, paddingBottom: 0, left: view.leftAnchor, paddingLeft: 15, right: nil, paddingRight: 0, width: 0, height: 0)
        
        finishTime.anchor(top: nil, paddingTop: 30, bottom: nil, paddingBottom: 0, left: nil, paddingLeft: 15, right: view.rightAnchor, paddingRight: 15, width: 0, height: 0)
        finishTime.centerYAnchor.constraint(equalTo: estimatedFinish.centerYAnchor).isActive = true
        
        garagename.anchor(top: estimatedFinish.bottomAnchor, paddingTop: 50, bottom: nil, paddingBottom: 0, left: view.leftAnchor, paddingLeft: 15, right: nil, paddingRight: 0, width: 0, height: 0)
        
        textfield.anchor(top: garagename.bottomAnchor, paddingTop: 20, bottom: nil, paddingBottom: 0, left: view.leftAnchor, paddingLeft: 15, right: nil, paddingRight: 0, width: 0, height: 40)
        textfield.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7).isActive = true
        
        phonebutton.anchor(top: nil, paddingTop: 20, bottom: nil, paddingBottom: 0, left: textfield.rightAnchor, paddingLeft: 15, right: nil, paddingRight: 0, width: 40, height: 40)
        phonebutton.centerYAnchor.constraint(equalTo: textfield.centerYAnchor).isActive = true
        
        
        
    }
    
    func addAMorPM(time: String) -> String {
        if Int(time.prefix(2)) ?? 12 < 12 {
            return "AM"
        }
        else {
            return "PM"
        }
        
    }
}
