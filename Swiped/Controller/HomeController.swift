//
//  ViewController.swift
//  Swiped
//
//  Created by Nitin on 23/05/25.
//

import UIKit

class HomeController: UIViewController {
    
    let topStackView = TopNavigationStackView()
    let cardsDeckView = UIView()
    let bottomStackView = HomeBottomControlsStackView()
    
    
    let cardViewModel = [
        User(name: "Nitin", age: 25, profession: "Software Engineer", imageName: "lady5c").toCardViewModel(),
        User(name: "Alice", age: 28, profession: "Designer", imageName: "lady4c").toCardViewModel(),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        
        setupDummyCards()
        
    }
    
    //MARK: FilePrivate
    
    fileprivate func setupDummyCards() {
        
        cardViewModel.forEach { value in
            let cardView = CardView(frame: .zero)
            cardView.imageView.image = UIImage(named: value.imageName)
            cardView.informationLabel.attributedText = value.attributedString
            cardView.informationLabel.textAlignment = value.textAlignment
            
            
            cardsDeckView.addSubview(cardView)
            cardView.fillSuperview()
            cardView.translatesAutoresizingMaskIntoConstraints = false
            cardView.layer.masksToBounds = true
            cardView.layer.cornerRadius = 10
        }
       
    }
    
    fileprivate func setupLayout() {
        let overallStackView = UIStackView(arrangedSubviews: [topStackView,cardsDeckView,bottomStackView])
        overallStackView.axis = .vertical
        
        view.addSubview(overallStackView)
        
        // Constraints
        overallStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
        overallStackView.isLayoutMarginsRelativeArrangement = true
        overallStackView.layoutMargins = .init(top: 0, left: 10, bottom: 0, right: 10)
        overallStackView.bringSubviewToFront(cardsDeckView)
    }


}

