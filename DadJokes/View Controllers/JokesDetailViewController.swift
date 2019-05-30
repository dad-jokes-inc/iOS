//
//  JokesDetailViewController.swift
//  DadJokes
//
//  Created by Hayden Hastings on 5/30/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class JokesDetailViewController: UIViewController {
    
    var joke: Joke? {
        didSet {
            updateViews()
        }
    }
    
    var jokeController: JokeController?
    var showDetail = false

    override func viewDidLoad() {
        super.viewDidLoad()

        updateViews()
    }
    
    // MARK: - Methods
    
    func updateViews() {
        guard isViewLoaded else { return }
        if let joke = joke?.joke {
            jokeTextView.text = "\(joke)"
        }
        
        if showDetail {
            saveButton.isHidden = true
            jokeTextView.isEditable = false
        } else {
            saveButton.isHidden = false
            jokeTextView.isEditable = true
            title = "Create A Joke!"
        }
        
    }
    
    // MARK: - IBActions

    @IBAction func saveButtonPressed(_ sender: Any) {
        guard let joke = jokeTextView.text,
            joke != "" else { return }
        
        jokeController?.createPublicJoke(jokeContent: joke, completion: { (error) in
            if let error = error {
                NSLog("Error creating joke: \(error)")
                return 
            }
        })
    }
    
    // MARK: - IBOutlets

    @IBOutlet weak var jokeTextView: UITextView!
    @IBOutlet weak var saveButton: UIButton!
}
