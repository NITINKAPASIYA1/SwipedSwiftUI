//
//  CardView.swift
//  Swiped
//
//  Created by Nitin on 24/05/25.
//

import UIKit
import SDWebImage

class CardView: UIView {
    
    fileprivate let threshold: CGFloat = 80
    fileprivate let imageView = UIImageView(frame: .zero)
    fileprivate let informationLabel = UILabel()
    fileprivate let barsStackView = UIStackView()
    fileprivate let barDeselectedColor = UIColor(white: 0 , alpha: 0.1)
    
    let gradientLayer = CAGradientLayer()
    
    var cardViewModel : CardViewModel! {
        didSet {
            if let url = URL(string: cardViewModel.imageNames.first ?? "") {
                imageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
            }
            informationLabel.attributedText = cardViewModel.attributedString
            informationLabel.textAlignment = cardViewModel.textAlignment
            
            (0..<cardViewModel.imageNames.count).forEach { _ in
                let barView = UIView()
                barView.backgroundColor = barDeselectedColor
                barsStackView.addArrangedSubview(barView)
            }
            barsStackView.arrangedSubviews.first?.backgroundColor = .white
            
            setupImageIndexObserver()
        }
    }
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
        
        // pan gesture ka kaam hai idhar se
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        addGestureRecognizer(panGesture)
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTab)))
    }
    
    fileprivate func setupImageIndexObserver() {
        cardViewModel.imageIndexObserver = { [unowned self]  (index,image) in
            print("Changing photo from view Model")
            self.imageView.image = image
            self.barsStackView.arrangedSubviews.forEach { $0.backgroundColor = self.barDeselectedColor }
            self.barsStackView.arrangedSubviews[index].backgroundColor = .white
        }
    }
    
    fileprivate func setupLayout() {
        //Custom Drawing code
        imageView.contentMode = .scaleAspectFill
        addSubview(imageView)
        imageView.fillSuperview()
        
        // Setup bar stack view
        setupBarsStackView()
        
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
    
    @objc private func handleTab(_ gesture: UITapGestureRecognizer) {
        let tapLocation = gesture.location(in: nil)
        let shouldAdvanceToNextPhoto = tapLocation.x > frame.width / 2 ? true : false
        
        if shouldAdvanceToNextPhoto {
            cardViewModel.advanceToNextPhoto()
        }
        else {
            cardViewModel.goToPreviousPhoto()
        }
        
    }
    
    fileprivate func setupBarsStackView() {
        addSubview(barsStackView)
        barsStackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor,padding: .init(top: 8, left: 8, bottom: 0, right: 8),size: .init(width: 0, height: 5))
        barsStackView.distribution = .fillEqually
        barsStackView.spacing = 5
        barsStackView.layer.cornerRadius = 2.5
        barsStackView.layer.masksToBounds = true
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
