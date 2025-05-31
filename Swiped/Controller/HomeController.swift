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
    
    
    let cardViewModel = ([
        User(name: "Nitin", age: 25, profession: "Software Engineer", imageNames: ["lady5c"]),
        User(name: "Alice", age: 28, profession: "Designer", imageNames: ["kelly1" , "kelly2" , "kelly3"]),
        Advertiser(title: "Slide Out Menu", brandName: "Lets Create the Future app", posterPhotoName: "lady5c"),
        User(name: "Jane", age: 12, profession: "teacher", imageNames: ["jane1", "jane2", "jane3"]),
    ] as [ProducesCardViewModel]).map { producer in
        return producer.toCardViewModel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupDummyCards()
        topStackView.settingsButton.addTarget(self, action: #selector(handleSettings), for: .touchUpInside)
    }
    
    //MARK: FilePrivate
    
    @objc fileprivate func handleSettings() {
        let registarionController = RegistrationController()
        registarionController.modalPresentationStyle = .fullScreen
        present(registarionController, animated: true)
        
    }
    
    fileprivate func setupDummyCards() {
        
        cardViewModel.forEach { value in
            let cardView = CardView(frame: .zero)
            cardView.cardViewModel = value
            
            cardsDeckView.addSubview(cardView)
            cardView.fillSuperview()
            cardView.translatesAutoresizingMaskIntoConstraints = false
            cardView.layer.masksToBounds = true
            cardView.layer.cornerRadius = 10
            view.backgroundColor = .systemBackground
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


#Preview{
    HomeController()
}
