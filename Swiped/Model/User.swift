//
//  User.swift
//  Swiped
//
//  Created by Nitin on 27/05/25.
//

import Foundation
import UIKit

struct User : ProducesCardViewModel {
    
    var name : String?
    var age : Int?
    var profession : String?
    var imageUrl1 : String?
    var uid : String?
    
    init(dictionary : [String : Any]) {
        let name = dictionary["fullName"] as? String ?? "Unknown"
        self.name = name
        self.age = dictionary["age"] as? Int
        self.profession = dictionary["profession"] as? String
        self.imageUrl1 = dictionary["imageUrl1"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
    }
    
    func toCardViewModel() -> CardViewModel {
        let attributedString = NSMutableAttributedString(string: name ?? "", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 32,weight: .heavy)])
        
        let ageString = age != nil ? "\(age!)" : "N\\A"
        
        attributedString.append(NSAttributedString(string: " \(ageString)", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24,weight: .light)]))
        
        let profession = profession != nil  ? profession! : "Not Available"
        
        
        attributedString.append(NSAttributedString(string: "\n\(profession)", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20,weight: .regular)]))

        
        return CardViewModel(imageNames: [imageUrl1 ?? ""], attributedString: attributedString, textAlignment: .left)
    }
}


