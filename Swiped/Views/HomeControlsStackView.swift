//
//  HomeControlsStackView.swift
//  Swiped
//
//  Created by Nitin on 23/05/25.
//

import UIKit

class HomeBottomControlsStackView: UIStackView {
    
    static func createButton(image: UIImage) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }
    
    let refresthButton = createButton(image: #imageLiteral(resourceName: "refresh_circle"))
    let dislikeButton = createButton(image: #imageLiteral(resourceName: "dismiss_circle"))
    let superLikeButton = createButton(image: #imageLiteral(resourceName: "super_like_circle"))
    let likeButton = createButton(image: #imageLiteral(resourceName: "like_circle"))
    let specialButton = createButton(image: #imageLiteral(resourceName: "boost_circle"))

    override init(frame: CGRect) {
        super.init(frame: frame)
        distribution = .fillEqually
        heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        [refresthButton, dislikeButton, superLikeButton, likeButton, specialButton].forEach { btn in
            self.addArrangedSubview(btn)
        }
            
    }
    
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
