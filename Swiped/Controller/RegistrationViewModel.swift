//
//  RegistrationViewModel.swift
//  Swiped
//
//  Created by Nitin on 30/05/25.
//
// yeh didset ka kya use hota hai > jab bhi koi value change hoti hai, yeh observer ko call karega yeh image observer hai, jo image change hone par call hota hai
import Foundation
import UIKit
import FirebaseAuth
import FirebaseStorage

class RegistrationViewModel {
    
    var bindableImage : Bindable<UIImage> = Bindable()
    var bindableIsFormValid = Bindable<Bool>()
    var bindableRegistering = Bindable<Bool>()

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
    
    func registerUser( completion : @escaping (Error?) -> Void) {
        guard let email = email else { return }
        guard let password = password else { return }
        bindableRegistering.value = true
        
        FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password) {  authResult, error in
            if let error = error {
                completion(error)
                return
            }
            
            print("Successfully registered user:", authResult?.user.email ?? "")
            
            // Only upload the image once you are authorized
            let filename = NSUUID().uuidString
            let ref = Storage.storage().reference(withPath: "/images/\(filename)")
            let imageData = self.bindableImage.value?.jpegData(compressionQuality: 0.75) ?? Data()
            ref.putData(imageData) { _, err in
                if let error = err {
                    completion(error)
                    print("Failed to upload image:", error.localizedDescription)
                    return
                }
                
                print("DEBUG : Successfully uploaded image to Firebase Storage")
                ref.downloadURL { url, err in
                    if let error = err {
                        completion(error)
                        return
                    }
                    
                    self.bindableRegistering.value = false
                    guard let profileImageUrl = url?.absoluteString else { return }
                    print("DEBUG : Download URL of image is \(profileImageUrl)")
                    completion(nil)
                    
                }
            }
            
        }
    }
    
    
    fileprivate func checkFromValidity() {
        let isValid = fullName?.isEmpty == false && email?.isEmpty == false && password?.isEmpty == false
        bindableIsFormValid.value = isValid
    }
    
}
