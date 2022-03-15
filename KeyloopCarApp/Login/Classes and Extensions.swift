//
//  Classes and Extensions.swift
//  KeyloopCarApp
//
//  Created by Christian Grinling on 01/02/2022.
//

import Foundation
import UIKit

extension UITextField {
    
    func signuptext(placeholder: String, returnkey: UIReturnKeyType, tag: Int, image: String) {
        
        self.placeholder = placeholder
        self.returnKeyType = returnkey
        autocorrectionType = .no
        autocapitalizationType = .none
        spellCheckingType = .no
        addImage(image: image, size: 10, colour: .black, weight: .bold, scale: .medium, padding: 40)
        self.tag = tag
    }
}

class darkblackbutton: UIButton {
    
    var documentID: String?

        static func textstring(text: String) -> darkblackbutton {
            let button = darkblackbutton()
            button.layout(textcolour: .white, backgroundColour: UIColor(hexString: "222222"), size: 16, text: text, image: nil, cornerRadius: 15)
            return button
        }
    
    static func textstringsize(text: String, size: CGFloat,cornerRadius:CGFloat) -> darkblackbutton {
        let button = darkblackbutton()
        button.layout(textcolour: .white, backgroundColour: UIColor(hexString: "222222"), size: size, text: text, image: nil, cornerRadius: cornerRadius)
        return button
    }
    
    static func textstringsizecolour(text: String, size: CGFloat,cornerRadius:CGFloat,colour: UIColor) -> darkblackbutton {
        let button = darkblackbutton()
        button.layout(textcolour: .white, backgroundColour: colour, size: size, text: text, image: nil, cornerRadius: cornerRadius)
        return button
    }
}

struct RootClass : Decodable {

        let images : [Image]?

        enum CodingKeys: String, CodingKey {
                case images = "images"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                images = try values.decode([Image].self, forKey: .images)
        }

}

struct Image: Decodable {
    let link: String
    let height: Int
    let width: Int
}

