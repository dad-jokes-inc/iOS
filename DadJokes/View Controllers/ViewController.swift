//
//  ViewController.swift
//  DadJokes
//
//  Created by Jeremy Taylor on 5/28/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let jokeController = JokeController()

    override func viewDidLoad() {
        super.viewDidLoad()
        jokeController.logIn(with: "Hayden", password: "Hastings") { (error) in
            if let error = error {
                print("Error loging in: \(error)")
                return
            }
        }
    }
}

