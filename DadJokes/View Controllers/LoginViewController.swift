//
//  LoginViewController.swift
//  DadJokes
//
//  Created by Hayden Hastings on 5/28/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Properties
    
    var jokeController: JokeController?
    var loginType: LoginType = .signUp
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    // MARK: - Enums

    enum LoginType {
        case logIn
        case signUp
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        passwordTextField.delegate = self
        
        setupAppearance()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    // MARK: - Methods
    
    @objc func keyboardWillChange(notification: Notification) {
        
        guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        if notification.name == UIResponder.keyboardWillShowNotification ||
            notification.name == UIResponder.keyboardWillChangeFrameNotification {
            
            view.frame.origin.y = -keyboardRect.height
        } else {
            view.frame.origin.y = 0
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        passwordTextField.resignFirstResponder()
        
        return true
    }
    
    func setupAppearance() {
        view.backgroundColor = AppearanceHelper.dadJokesBlue
        
        emailTextField.layer.borderColor = AppearanceHelper.dadJokesGreyishWhite.cgColor
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email:", attributes: [NSAttributedString.Key.foregroundColor: AppearanceHelper.dadJokesGreyishWhite])
        emailTextField.textColor = AppearanceHelper.dadJokesGreyishWhite
        emailTextField.layer.borderWidth = 1
        emailTextField.layer.cornerRadius = 10
        emailTextField.backgroundColor = .clear
        
        passwordTextField.layer.borderColor = AppearanceHelper.dadJokesGreyishWhite.cgColor
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password:", attributes: [NSAttributedString.Key.foregroundColor: AppearanceHelper.dadJokesGreyishWhite])
        passwordTextField.textColor = AppearanceHelper.dadJokesGreyishWhite
        passwordTextField.layer.borderWidth = 1
        passwordTextField.layer.cornerRadius = 10
        passwordTextField.backgroundColor = .clear
        
        button.layer.backgroundColor = AppearanceHelper.dadJokesYellow.cgColor
        button.layer.cornerRadius = 10
        button.tintColor = AppearanceHelper.dadJokesBlue
        
        noAccountLabel.textColor = AppearanceHelper.dadJokesGreyishWhite
        
        entryMethodSegmentedControl.layer.backgroundColor = AppearanceHelper.dadJokesYellow.cgColor
        entryMethodSegmentedControl.layer.cornerRadius = 10
        entryMethodSegmentedControl.layer.borderWidth = 1
        entryMethodSegmentedControl.layer.borderColor = AppearanceHelper.dadJokesYellow.cgColor
        entryMethodSegmentedControl.tintColor = AppearanceHelper.dadJokesBlue
    }
    
    // MARK: - Actions
    @IBAction func loginButtonPressed(_ sender: Any) {
        guard let username = emailTextField.text,
            let password = passwordTextField.text else { return }
        
        if loginType == .signUp {
            jokeController?.createUser(name: username, password: password, completion: { (error) in
                if let error = error {
                    NSLog("Error signing up \(error)")
                } else {
                    DispatchQueue.main.async {
                        let alertController = UIAlertController(title: "Sign Up Successful!", message: "Please log in", preferredStyle: .alert)
                        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alertController.addAction(alertAction)
                        self.present(alertController, animated: true, completion: {
                            self.loginType = .logIn
                            self.entryMethodSegmentedControl.selectedSegmentIndex = 1
                            self.button.setTitle("Sign In", for: .normal)
                        })
                    }
                }
            })
        } else {
            jokeController?.logIn(with: username, password: password, completion: { (error) in
                if let error = error {
                    NSLog("Error logging in: \(error)")
                } else {
                    DispatchQueue.main.async {
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            })
        }
    }
    
    @IBAction func entryMethodChanged(_ sender: Any) {
        if entryMethodSegmentedControl.selectedSegmentIndex == 0 {
            loginType = .signUp
            button.setTitle("Sign Up", for: .normal)
            navigationItem.title = "Sign Up"
        } else {
            loginType = .logIn
            button.setTitle("Log In", for: .normal)
            navigationItem.title = "Log In"
        }
    }
    // MARK: - Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var entryMethodSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var noAccountLabel: UILabel!
}
