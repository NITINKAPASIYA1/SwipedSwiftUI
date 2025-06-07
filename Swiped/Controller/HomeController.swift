//
//  ViewController.swift
//  Swiped
//
//  Created by Nitin on 23/05/25.
//

import UIKit
import FirebaseFirestore
import JGProgressHUD

class HomeController: UIViewController {
    
    let topStackView = TopNavigationStackView()
    let cardsDeckView = UIView()
    let bottomControls = HomeBottomControlsStackView()
    
    var cardViewModel = [CardViewModel]()
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        super.viewDidLoad()
        bottomControls.refresthButton.addTarget(self, action: #selector(handleRefresh), for: .touchUpInside)
        setupLayout()
        setupFirestoreUserCards()
        topStackView.settingsButton.addTarget(self, action: #selector(handleSettings), for: .touchUpInside)
        fetchUsersfromFirestore()
    }
    
    //MARK: FilePrivate
    
    @objc fileprivate func handleRefresh() {
        fetchUsersfromFirestore()
    }
    
    var lastFetchedUser: User?
    
    @objc fileprivate func fetchUsersfromFirestore() {
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Fetching users..."
        hud.show(in: view)
        // i will introduct pagaination here
        
        let query = Firestore.firestore().collection("users").order(by: "uid").start(after: [lastFetchedUser?.uid ?? ""]).limit(to: 2)
        query.getDocuments { snapshot, error in
            hud.dismiss(animated: true)
            if let error = error {
                print("Failed to fetch users:", error)
                return
            }
            
            guard let documents = snapshot?.documents else { return }
            
            documents.forEach { (doc) in
                let userDictionary = doc.data()
                let user = User(dictionary: userDictionary)
                self.cardViewModel.append(user.toCardViewModel())
                self.lastFetchedUser = user
                self.setupCardFromUser(user: user)
            }
        }

    }
    
    fileprivate func setupCardFromUser(user:User) {
        let cardView = CardView(frame: .zero)
        cardView.cardViewModel = user.toCardViewModel()
        cardsDeckView.addSubview(cardView)
        cardsDeckView.sendSubviewToBack(cardView)
        cardView.fillSuperview()
        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.layer.masksToBounds = true
        cardView.layer.cornerRadius = 10
        view.backgroundColor = .systemBackground
    }
    
    @objc fileprivate func handleSettings() {
        let registarionController = RegistrationController()
        registarionController.modalPresentationStyle = .fullScreen
        present(registarionController, animated: true)
        
    }
    
    fileprivate func setupFirestoreUserCards() {
        
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
        let overallStackView = UIStackView(arrangedSubviews: [topStackView,cardsDeckView,bottomControls])
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
