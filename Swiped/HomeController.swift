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
    
    let users : [User] = [
        User(name: "Nitin", age: 25, profession: "Software Engineer", imageName: "lady5c"),
        User(name: "Alice", age: 28, profession: "Designer", imageName: "lady5c"),
        User(name: "Bob", age: 30, profession: "Photographer", imageName: "lady5c"),
        User(name: "Charlie", age: 27, profession: "Artist", imageName: "lady5c")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        
        setupDummyCards()
        
    }
    
    //MARK: FilePrivate
    
    fileprivate func setupDummyCards() {
        
        users.forEach { value in
            let cardView = CardView(frame: .zero)
            cardView.imageView.image = UIImage(named: value.imageName)
            cardView.informationLabel.text = "\(value.name) \(value.age)\n \(value.profession)"
            
            let attributedString = NSMutableAttributedString(string: value.name, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 32,weight: .heavy)])
            
            attributedString.append(NSAttributedString(string: " \(value.age)", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24,weight: .light)]))
            
            attributedString.append(NSAttributedString(string: "\n\(value.profession)", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20,weight: .regular)]))
            
            cardView.informationLabel.attributedText = attributedString
            
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

