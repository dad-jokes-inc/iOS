//
//  JokesTableViewController.swift
//  DadJokes
//
//  Created by Jeremy Taylor on 5/30/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class JokesTableViewController: UITableViewController {
    
    let jokeController = JokeController.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        jokeController.fetchPublicJokes { (error) in
            if let error = error {
                print(error)
                return
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        jokeController.fetchPublicJokes { (error) in
            if let error = error {
                print(error)
                return
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        guard let _ = jokeController.bearer else { return }
        jokeController.fetchAllJokes { (error) in
            if let error = error {
                print(error)
                return
            }
            
            DispatchQueue.main.async {
                self.navigationItem.leftBarButtonItem?.isEnabled = false
                self.navigationItem.leftBarButtonItem?.tintColor = .clear
                self.tableView.reloadData()
            }
        }
        
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return jokeController.publicJokes.count
        } else {
            return jokeController.jokes.count
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JokeCell", for: indexPath)
        
        if indexPath.section == 0 {
            let joke = jokeController.publicJokes[indexPath.row]
            cell.textLabel?.text = joke.publicJoke
        } else if indexPath.section == 1 {
            let joke = jokeController.jokes[indexPath.row]
            cell.textLabel?.text = joke.joke
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Public Jokes"
        } else {
            return "Private Jokes"
        }
    }
    
   
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }    
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ShowEditVC" {
            guard let destinationVC = segue.destination as? JokesDetailViewController else {
                print("Nope!")
                return
            }
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            if indexPath.section == 0 {
                let publicJoke = jokeController.publicJokes[indexPath.row]
                destinationVC.publicJoke = publicJoke
                destinationVC.showDetail = true
            } else {
                let joke = jokeController.jokes[indexPath.row]
                destinationVC.joke = joke
                destinationVC.showDetail = true
            }
        }
    }
}
