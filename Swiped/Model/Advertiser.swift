//
//  Advertiser.swift
//  Swiped
//
//  Created by Nitin on 28/05/25.
//

import Foundation
import UIKit

struct Advertiser : ProducesCardViewModel {
    
    let title : String
    let brandName : String
    let posterPhotoName : String
    
    func toCardViewModel() -> CardViewModel {
        let attributedString = NSMutableAttributedString(string: title, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 32,weight: .heavy)])
        
        attributedString.append(NSAttributedString(string: "\n" + brandName, attributes: [.font:UIFont.systemFont(ofSize: 24, weight: .bold)]))
        
        return CardViewModel(imageName: posterPhotoName, attributedString: attributedString, textAlignment: .center)
    }
}
