//
//  LoginViewController.swift
//  DadJokes
//
//  Created by Hayden Hastings on 5/28/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: - Properties
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    // MARK: - Enums

    override func viewDidLoad() {
        super.viewDidLoad()

        setupAppearance()
    }
    
    // MARK: - Methods
    
    func setupAppearance() {
        view.backgroundColor = AppearanceHelper.dadJokesBlue
        
        emailTextField.layer.borderColor = AppearanceHelper.dadJokesGreyishWhite.cgColor
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email:", attributes: [NSAttributedString.Key.foregroundColor: AppearanceHelper.dadJokesGreyishWhite])
        emailTextField.layer.borderWidth = 1
        emailTextField.layer.cornerRadius = 10
        emailTextField.backgroundColor = .clear
        
        passwordTextField.layer.borderColor = AppearanceHelper.dadJokesGreyishWhite.cgColor
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password:", attributes: [NSAttributedString.Key.foregroundColor: AppearanceHelper.dadJokesGreyishWhite])
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
        
    }
    
    @IBAction func entryMethodChanged(_ sender: Any) {
        
    }
    // MARK: - Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var entryMethodSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var noAccountLabel: UILabel!
}
