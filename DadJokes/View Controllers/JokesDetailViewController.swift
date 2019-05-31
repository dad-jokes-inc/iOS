//
//  JokesDetailViewController.swift
//  DadJokes
//
//  Created by Hayden Hastings on 5/30/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class JokesDetailViewController: UIViewController, UITextViewDelegate {
    
    var joke: Joke? {
        didSet {
            updateViews()
        }
    }
    
    var publicJoke: PublicJoke? {
        didSet {
            updateViews()
        }
    }
    
    let jokeController = JokeController.shared
    var showDetail = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        jokeTextView.delegate = self
        
        updateViews()
        setupAppearance()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    // MARK: - Methods
    
    func updateViews() {
        guard isViewLoaded else { return }
        if let joke = joke?.joke {
            jokeTextView.text = "\(joke)"
        }
        
        if let publicJoke = publicJoke?.publicJoke {
            jokeTextView.text = "\(publicJoke)"
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
    
    func setupAppearance() {
        view.backgroundColor = AppearanceHelper.dadJokesBlue
        jokeTextView.backgroundColor = AppearanceHelper.dadJokesBlue
        jokeTextView.layer.borderWidth = 1
        jokeTextView.layer.borderColor = AppearanceHelper.dadJokesYellow.cgColor
        jokeTextView.textColor = .white
        
        saveButton.tintColor = AppearanceHelper.dadJokesGreyishWhite
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        jokeTextView.resignFirstResponder()
        
        return true
    }
    
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
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
    }
    
    // MARK: - IBActions
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        guard let joke = jokeTextView.text,
            joke != "" else { return }
        
        jokeController.createPublicJoke(jokeContent: joke, completion: { (error) in
            if let error = error {
                NSLog("Error creating joke: \(error)")
                return 
            }
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        })
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var jokeTextView: UITextView!
    @IBOutlet weak var saveButton: UIButton!
    
    // MARK: - IBActions
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
