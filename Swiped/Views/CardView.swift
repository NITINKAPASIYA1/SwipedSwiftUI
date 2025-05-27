//
//  CardView.swift
//  Swiped
//
//  Created by Nitin on 24/05/25.
//

import UIKit

class CardView: UIView {
    
    fileprivate let imageView = UIImageView(image: UIImage(resource: .lady5C))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //Custom Drawing code
        addSubview(imageView)
        imageView.fillSuperview()
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        addGestureRecognizer(panGesture)
    }
    
    fileprivate func handleChanged(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)
        self.transform = CGAffineTransform(translationX: translation.x, y: translation.y)
    }
    
    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        
        
        switch gesture.state {
        case .changed:
            handleChanged(gesture)
        case .ended:
            UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut,animations: {
                self.transform = .identity
            }, completion: nil)
        default:
            ()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
