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

struct CardViewModel {
    //we will define the properties that are view will display/render
    let imageName : String
    let attributedString : NSAttributedString
    let textAlignment : NSTextAlignment
}
