//
//  CardView.swift
//  Swiped
//
//  Created by Nitin on 24/05/25.
//

import UIKit

class CardView: UIView {
    
    var cardViewModel : CardViewModel! {
        didSet {
            imageView.image = UIImage(named: cardViewModel.imageName)
            informationLabel.attributedText = cardViewModel.attributedString
            informationLabel.textAlignment = cardViewModel.textAlignment
        }
    }
    
    fileprivate let threshold: CGFloat = 80
    fileprivate let imageView = UIImageView(frame: .zero)
    fileprivate let informationLabel = UILabel()
    
    let gradientLayer = CAGradientLayer()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
        
        // pan gesture ka kaam hai idhar se
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        addGestureRecognizer(panGesture)
    }
    
    
    fileprivate func setupLayout() {
        //Custom Drawing code
        imageView.contentMode = .scaleAspectFill
        addSubview(imageView)
        imageView.fillSuperview()
        
        // add a gradient layer somehow
        setupGradientLayer()
        addSubview(informationLabel)
        informationLabel.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 16, bottom: 16, right: 0), size: .init(width: 0, height: 80))
        informationLabel.textColor = .white
        informationLabel.numberOfLines = 0
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
    
    fileprivate func setupGradientLayer() {
       
        gradientLayer.colors = [UIColor.clear.cgColor,UIColor.black.cgColor]
        gradientLayer.locations = [0.5,1.1]
        //now set the fram
        layer.addSublayer(gradientLayer)
    }
    
    override func layoutSubviews() {
        //apko idhar pata hota ki apna cardView ka frame kya hai
        gradientLayer.frame = self.frame
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
