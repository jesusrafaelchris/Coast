//
//  InputContainerView.swift
//  KeyloopCarApp
//
//  Created by Christian Grinling on 09/02/2022.
//

import Foundation


import Foundation
import UIKit

class InputAccessoryView: UIView, UITextViewDelegate {
    
    weak var messagelog: MessageLog? {
        didSet {
            camerabutton.addTarget(messagelog, action: #selector(MessageLog.openCamera), for: .touchUpInside)
            uploadImageView.addGestureRecognizer(UITapGestureRecognizer(target: messagelog, action: #selector(MessageLog.handleImagePicker)))
        }
    }
    
    lazy var Textbox: UITextView = {
        let textview = UITextView()
        textview.translatesAutoresizingMaskIntoConstraints = false
        textview.textColor = .black
        textview.font = UIFont.systemFont(ofSize: 18)
        textview.isScrollEnabled = true
        textview.returnKeyType = .send
        textview.delegate = self
        textview.isUserInteractionEnabled = true
        textview.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        textview.layer.cornerRadius = 15
        textview.layer.masksToBounds = true
        return textview
    }()
    
    lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Message"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .lightGray
        return label
    }()
    
    let uploadImageView: UIButton = {
        let button = UIButton()
        button.layout(textcolour: nil , backgroundColour: UIColor(hexString: "F6F6F6"), size: nil, text: "", image: UIImage(systemName: "photo")?.withTintColor(UIColor(hexString: "222222")).withRenderingMode(.alwaysOriginal), cornerRadius: 20)
        return button
    }()
    
    let camerabutton: UIButton = {
        let button = UIButton()
        button.layout(textcolour: nil , backgroundColour: UIColor(hexString: "F6F6F6"), size: nil, text: "", image: UIImage(systemName: "camera")?.withTintColor(UIColor(hexString: "222222")).withRenderingMode(.alwaysOriginal), cornerRadius: 20)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        self.autoresizingMask = UIView.AutoresizingMask.flexibleHeight
    }
        
    var seperatorlinetopanchor:NSLayoutConstraint?

    
    func setupViews() {
       backgroundColor = .white
       
       addSubview(uploadImageView)
       addSubview(self.Textbox)
       addSubview(camerabutton)
       addSubview(placeholderLabel)
       //x,y,w,h
    
      self.placeholderLabel.centerYAnchor.constraint(equalTo: Textbox.centerYAnchor).isActive = true
      self.placeholderLabel.leftAnchor.constraint(equalTo: Textbox.leftAnchor, constant: 10).isActive = true
        
       uploadImageView.anchor(top: topAnchor, paddingTop: 5, bottom: bottomAnchor, paddingBottom: 5, left: leftAnchor, paddingLeft: 5, right: nil, paddingRight: 0, width: 40, height: 40)
    
        camerabutton.anchor(top: topAnchor, paddingTop: 5, bottom: bottomAnchor, paddingBottom: 5, left: uploadImageView.rightAnchor, paddingLeft: 5, right: nil, paddingRight: 0, width: 40, height: 40)
        
        self.Textbox.leftAnchor.constraint(equalTo: camerabutton.rightAnchor, constant: 8).isActive = true
        self.Textbox.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        self.Textbox.rightAnchor.constraint(equalTo: rightAnchor, constant: -15).isActive = true
        self.Textbox.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.7).isActive = true

        
       let separatorLineView = UIView()
        separatorLineView.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 0.8)
       separatorLineView.translatesAutoresizingMaskIntoConstraints = false
       addSubview(separatorLineView)
       //x,y,w,h
       separatorLineView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
       separatorLineView.topAnchor.constraint(equalTo: topAnchor).isActive = true
       separatorLineView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        separatorLineView.heightAnchor.constraint(equalToConstant: 0.4).isActive = true
       
       //textfield constraints
        

       
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        Textbox.resignFirstResponder()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            messagelog?.sendMessage()
        }
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
      self.invalidateIntrinsicContentSize()
        if textView.text == "\n" {
            textView.text = nil
        }
      let newAlpha: CGFloat = textView.text.isEmpty ? 1 : 0
        if placeholderLabel.alpha != newAlpha {
        UIView.animate(withDuration: 0.01) {
            self.placeholderLabel.alpha = newAlpha
        }
      }
        let size = CGSize(width: self.frame.width * 0.7, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        textView.constraints.forEach { (constraint) in
            if constraint.firstAttribute == .height {
                constraint.constant = estimatedSize.height
            }
        }
    }
    
    override var intrinsicContentSize: CGSize {
        // Calculate intrinsicContentSize that will fit all the text
        let textSize = self.Textbox.sizeThatFits(CGSize(width: self.Textbox.bounds.width, height: CGFloat.greatestFiniteMagnitude))
        return CGSize(width: self.bounds.width, height: textSize.height)
    }


    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}


