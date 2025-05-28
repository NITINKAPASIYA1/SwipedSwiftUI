//
//  User.swift
//  Swiped
//
//  Created by Nitin on 27/05/25.
//

import Foundation
import UIKit

struct User : ProducesCardViewModel {
    let name : String
    let age : Int
    let profession : String
    let imageNames : [String]
    
    func toCardViewModel() -> CardViewModel {
        let attributedString = NSMutableAttributedString(string: name, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 32,weight: .heavy)])
        
        attributedString.append(NSAttributedString(string: " \(age)", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24,weight: .light)]))
        
        attributedString.append(NSAttributedString(string: "\n\(profession)", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20,weight: .regular)]))

        
        return CardViewModel(imageNames: imageNames, attributedString: attributedString, textAlignment: .left)
    }
}


