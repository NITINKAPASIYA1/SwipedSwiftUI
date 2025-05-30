//
//  RegistrationViewModel.swift
//  Swiped
//
//  Created by Nitin on 30/05/25.
//

import Foundation

class RegistrationViewModel {
    
    var fullName: String? {
        didSet{
            checkFromValidity()
        }
    }
    var email: String? {
        didSet {
            checkFromValidity()
        }
    }
    var password: String? {
        didSet{
            checkFromValidity()
        }
    }
    
    fileprivate func checkFromValidity() {
        let isValid = fullName?.isEmpty == false && email?.isEmpty == false && password?.isEmpty == false
        isFormValidObserver?(isValid)
    }
    
    // Reactive Programming
    var isFormValidObserver : ((Bool) -> ())?
}
