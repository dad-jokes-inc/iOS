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
            checkIfUpdatingJoke()
        }
    }
    
    var publicJoke: PublicJoke? {
        didSet {
            updateViews()
        }
    }
    
    let jokeController = JokeController.shared
    var showDetail = false
    var updatingJoke = false
    var jokeID: Int? // For updating our private jokes
    
    override func viewDidLoad() {
        super.viewDidLoad()

        jokeTextView.delegate = self
    
        updateViews()
        setupAppearance()
        checkIfUpdatingJoke()
        
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
            savePrivateJokeButton.isHidden = true
            jokeTextView.isEditable = false
        } else {
            saveButton.isHidden = false
            jokeTextView.isEditable = true
            title = "Create A Joke!"
        }
        
        guard let _ = jokeController.bearer else {
            savePrivateJokeButton.isHidden = true
            return
        }
        
    }
    
    func checkIfUpdatingJoke() {
        guard isViewLoaded else { return }
        if let joke = joke {
            if let name = jokeController.user?.username  {
                if name == joke.userName {
                    // This is our joke we can update it
                    updatingJoke = true
                    if let id = joke.id {
                        jokeID = id
                    }
                    jokeTextView.isEditable = true
                    
                } else {
                    updatingJoke = false
                    
                }
            }
        }
    }
    
    func setupAppearance() {
        view.backgroundColor = AppearanceHelper.dadJokesBlue
        jokeTextView.backgroundColor = AppearanceHelper.dadJokesBlue
        jokeTextView.layer.borderWidth = 1
        jokeTextView.layer.borderColor = AppearanceHelper.dadJokesYellow.cgColor
        jokeTextView.textColor = .white
        jokeTextView.tintColor = AppearanceHelper.dadJokesYellow
        
        textLeabel.textColor = .white
        
        saveButton.tintColor = AppearanceHelper.dadJokesGreyishWhite
        savePrivateJokeButton.tintColor = AppearanceHelper.dadJokesGreyishWhite
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        jokeTextView.resignFirstResponder()
        
        return true
    }
    
    @objc func keyboardWillChange(notification: Notification) {
        
        view.frame.origin.y = -100
        
//        guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
//            return
//        }
//
//        if notification.name == UIResponder.keyboardWillShowNotification ||
//            notification.name == UIResponder.keyboardWillChangeFrameNotification {
//
//            view.frame.origin.y = -keyboardRect.height
//        } else {
//            view.frame.origin.y = 0
//        }
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
                self.navigationController?.popViewController(animated: true)
            }
        })
    }
    
    
    @IBAction func savePrivateJokeButtonPressed(_ sender: Any) {
        guard let joke = jokeTextView.text,
            joke != "" else { return }
        guard let userID = jokeController.user?.id else { return }
        
            jokeController.createJoke(userID: userID, jokeContent: joke) { (error) in
                if let error = error {
                    NSLog("Error creating private joke: \(error)")
                    return
                }
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    
    @IBAction func cancel(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var jokeTextView: UITextView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var savePrivateJokeButton: UIButton!
    @IBOutlet weak var textLeabel: UILabel!
}
