//
//  TopNavigationStackView.swift
//  SwipeMatchFirestoreLBTA
//
//  Created by Brian Voong on 11/1/18.
//  Copyright © 2018 Brian Voong. All rights reserved.
//

import UIKit

class TopNavigationStackView: UIStackView {
    
    let settingsButton = UIButton(type: .system)
    let messageButton = UIButton(type: .system)
    let fireImageView = UIImageView(image: #imageLiteral(resourceName: "Image"))

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        fireImageView.contentMode = .scaleAspectFit
        
        settingsButton.setImage(UIImage(systemName: "gear")?.withRenderingMode(.alwaysOriginal), for: .normal)
        messageButton.setImage(UIImage(systemName: "message")?.withRenderingMode(.alwaysTemplate), for: .normal)
        messageButton.tintColor = .gray
       
        
        [settingsButton, UIView(), fireImageView, UIView(), messageButton].forEach { view in
            addArrangedSubview(view)
        }
        
        distribution = .equalCentering
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = .init(top: 0, left: 16, bottom: 0, right: 16)
        
        // Instead, set constraints that work with the parent view's height
        fireImageView.widthAnchor.constraint(equalTo: fireImageView.heightAnchor).isActive = true
        fireImageView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init(coder: NSCoder) {
        fatalError()
    }

}

