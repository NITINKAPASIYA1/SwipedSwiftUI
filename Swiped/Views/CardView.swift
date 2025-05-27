//
//  CardView.swift
//  Swiped
//
//  Created by Nitin on 24/05/25.
//

import UIKit

class CardView: UIView {
    
    let imageView = UIImageView(frame: .zero)
    var informationLabel = UILabel()
    
    fileprivate let threshold: CGFloat = 80
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //Custom Drawing code
        addSubview(imageView)
        addSubview(informationLabel)
        informationLabel.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 16, bottom: 16, right: 0), size: .init(width: 0, height: 80))
        informationLabel.text = "Nitin, 25, Software Engineer"
        informationLabel.textColor = .white
        informationLabel.font = UIFont.systemFont(ofSize: 34,weight: .heavy)
        informationLabel.numberOfLines = 0
        
        
        imageView.fillSuperview()
        imageView.contentMode = .scaleAspectFill
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        addGestureRecognizer(panGesture)
    }
    
    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        
        switch gesture.state {
        case .changed:
            handleChanged(gesture)
        case .ended:
            handleEnded(gesture)
        default:
            ()
        }
        
    }
    
    fileprivate func handleChanged(_ gesture: UIPanGestureRecognizer) {
        //Rotation down
        let translation = gesture.translation(in: self)
        let degree : CGFloat = translation.x / 20
        let angle = degree * .pi / 180
        let rotationalTransformation = CGAffineTransform(rotationAngle:angle)
        self.transform = rotationalTransformation.translatedBy(x: translation.x, y: translation.y)
        
    }
    
    fileprivate func handleEnded(_ gesture: UIPanGestureRecognizer) {
        
        
        let shouldDismissCard = gesture.translation(in: nil).x > threshold || gesture.translation(in: nil).x < -threshold
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .curveEaseOut,animations: {
            
            if shouldDismissCard {
                // Dismiss the card
                let swipeDirection = gesture.translation(in: nil).x > 0 ? 1 : -1
                let offScreenTransform = self.transform.translatedBy(x: CGFloat(600 * (swipeDirection)), y: 0)
                self.transform = offScreenTransform
            }
            else{
                self.transform = .identity
            }
        }, completion:{ _ in
//            self.transform = .identity
        }
        )
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
