//
//  CardViewModel.swift
//  Swiped
//
//  Created by Nitin on 28/05/25.
//

import Foundation
import UIKit

protocol ProducesCardViewModel {
    func toCardViewModel() -> CardViewModel
}

//view Model is supposed to repesent the state of our view
class CardViewModel {
    //we will define the properties that are view will display/render
    let imageNames : [String]
    let attributedString : NSAttributedString
    let textAlignment : NSTextAlignment
    
    init(imageNames: [String], attributedString: NSAttributedString, textAlignment: NSTextAlignment) {
        self.imageNames = imageNames
        self.attributedString = attributedString
        self.textAlignment = textAlignment
    }
    
    fileprivate var imageindex : Int = 0 {
        didSet{
            let imageUrl = imageNames[imageindex]
//            let image = UIImage(named:imageName)
            imageIndexObserver?(imageindex,imageUrl)
        }
    }
    
    //Reactive Programming
    var imageIndexObserver : ((Int,String) -> () )?
    
    func advanceToNextPhoto() {
        imageindex = min(imageindex + 1, imageNames.count - 1)
    }
    
    func goToPreviousPhoto() {
        imageindex = max(0, imageindex - 1)
    }
    
    
}
