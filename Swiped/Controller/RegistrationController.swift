//
//  RegistrationController.swift
//  Swiped
//
//  Created by Nitin on 30/05/25.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import JGProgressHUD

class RegistrationController: UIViewController {
    
    // MARK: - UI Components
    
    private let photoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Select Photo", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        button.backgroundColor = .white
        button.setTitleColor(.gray, for: .normal)
        button.layer.cornerRadius = 16
        button.clipsToBounds = true
        button.imageView?.contentMode = .scaleAspectFill
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.addTarget(self, action: #selector(handleSelectPhoto), for: .touchUpInside)
        return button
    }()
    
    private let nameTextField: CustomTextField = {
        let tf = CustomTextField(padding: 16)
        tf.placeholder = "Enter your name"
        tf.backgroundColor = .white
        tf.keyboardType = .default
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return tf
    }()
    
    private let emailTextField: CustomTextField = {
        let tf = CustomTextField(padding: 16)
        tf.placeholder = "Enter email"
        tf.keyboardType = .emailAddress
        tf.backgroundColor = .white
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return tf
    }()
    
    private let passwordTextField: CustomTextField = {
        let tf = CustomTextField(padding: 16)
        tf.placeholder = "Enter password"
        tf.isSecureTextEntry = true
        tf.backgroundColor = .white
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return tf
    }()
    
    private let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Register", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        button.backgroundColor = .lightGray
        button.isEnabled = false
        button.layer.cornerRadius = 25
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        return button
    }()
    
    private let goToLoginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Already have an account? Sign In", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handleGoToLogin), for: .touchUpInside)
        return button
    }()
    
    private let gradientLayer = CAGradientLayer()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradientLayer()
        setupLayout()
        setupNotificationObservers()
        setupTapGesture()
        setupRegistrationViewModelObserver()
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        gradientLayer.frame = view.bounds
    }
    
    // MARK: - Setup
    
    fileprivate func setupGradientLayer() {
        let topColor = #colorLiteral(red: 0.9921568627, green: 0.3568627451, blue: 0.3725490196, alpha: 1)
        let bottomColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
        
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        gradientLayer.locations = [0, 1]
        view.layer.addSublayer(gradientLayer)
        gradientLayer.frame = view.bounds
    }
    
    fileprivate func setupLayout() {
        view.addSubview(photoButton)
        photoButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            photoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            photoButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            photoButton.widthAnchor.constraint(equalToConstant: 200),
            photoButton.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        let stackView = UIStackView(arrangedSubviews: [
            nameTextField,
            emailTextField,
            passwordTextField,
            registerButton
        ])
        stackView.axis = .vertical
        stackView.spacing = 16
        
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: photoButton.bottomAnchor, constant: 32),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
        
        view.addSubview(goToLoginButton)
        goToLoginButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            goToLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            goToLoginButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    let registrationViewModel = RegistrationViewModel()
    
    fileprivate func setupRegistrationViewModelObserver() {
        registrationViewModel.bindableIsFormValid.bind { [unowned self] isFormValid in
            self.registerButton.isEnabled = isFormValid!
            self.registerButton.backgroundColor = isFormValid ?? false ?
                #colorLiteral(red: 0.8980392157, green: 0, blue: 0.4470588235, alpha: 1) : .lightGray
        }

        
        registrationViewModel.bindableImage.bind { [unowned self] img in
            self.photoButton.setImage(img?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        registrationViewModel.bindableRegistering.bind { [unowned self] isRegistering in
            if isRegistering == true {
                self.registerHUD.textLabel.text = "Registering..."
                self.registerHUD.show(in: self.view)
            } else {
                self.registerHUD.dismiss(animated: true)
            }
        }
    }

    @objc fileprivate func handleTextChange(textField: UITextField) {
        // Update view model with text field values
        registrationViewModel.fullName = nameTextField.text ?? ""
        registrationViewModel.email = emailTextField.text ?? ""
        registrationViewModel.password = passwordTextField.text ?? ""
        
        // The button state will be updated via the isFormValidObserver
    }
    
    fileprivate func setupNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    fileprivate func setupTapGesture() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss)))
    }
    
    
    
    // MARK: - Actions
    
    @objc fileprivate func handleSelectPhoto() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        present(imagePickerController, animated: true)
    }
    
    let registerHUD = JGProgressHUD(style: .dark)
    
    @objc fileprivate func handleRegister() {
        // Implement registration logic
        print("Register button tapped")

        registrationViewModel.registerUser {[weak self] error in
            if let err = error {
                self?.setupJUD(err)
                return
            }
            
            print("Successfully registered user")
        }
       

    }
    
    fileprivate func setupJUD(_ err : Error) {
        registerHUD.dismiss(animated: true)
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Registration Failed"
        hud.detailTextLabel.text = err.localizedDescription
        hud.show(in: self.view)
        hud.dismiss(afterDelay: 4.0)
    }
    
    @objc fileprivate func handleGoToLogin() {
        // Navigate to login screen
        dismiss(animated: true)
    }
    
    @objc fileprivate func handleKeyboardShow(notification: Notification) {
        guard let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardFrame = value.cgRectValue
        
        // Find the gap between register button and keyboard
        let bottomSpace = view.frame.height - (registerButton.frame.origin.y + registerButton.frame.height)
        let difference = keyboardFrame.height - bottomSpace
        
        if difference > 0 {
            view.transform = CGAffineTransform(translationX: 0, y: -difference - 16)
        }
    }
    
    @objc fileprivate func handleKeyboardHide() {
        view.transform = .identity
    }
    
    @objc fileprivate func handleTapDismiss() {
        view.endEditing(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
}

// MARK: - UIImagePickerControllerDelegate

extension RegistrationController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let selectedImage = info[.originalImage] as? UIImage
        registrationViewModel.bindableImage.value = selectedImage
//        registrationViewModel.image = selectedImage
       
        photoButton.setTitle("", for: .normal)
        dismiss(animated: true)
    }
}


