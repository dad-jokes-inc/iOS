//
//  LoginViewController.swift
//  DadJokes
//
//  Created by Hayden Hastings on 5/28/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    
}
