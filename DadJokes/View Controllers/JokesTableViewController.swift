//
//  JokesTableViewController.swift
//  DadJokes
//
//  Created by Jeremy Taylor on 5/30/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class JokesTableViewController: UITableViewController {
    let jokeController = JokeController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        jokeController.createPublicJoke(jokeContent: "Test Public Joke from Jeremy") { (error) in
            
        }
        
        jokeController.fetchPublicJokes { (error) in
            if let error = error {
                print(error)
                return
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        guard let _ = jokeController.bearer else {
            jokeController.fetchPublicJokes { (error) in
                if let error = error {
                    print(error)
                    return
                }
            }
            return
        }
        jokeController.fetchAllJokes { (error) in
            if let error = error {
                print(error)
                return
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
        
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let _ = jokeController.bearer {
            return jokeController.jokes.count
        }
        
        return jokeController.publicJokes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JokeCell", for: indexPath)
        
        if let _ = jokeController.bearer {
           let joke = jokeController.jokes[indexPath.row]
            cell.textLabel?.text = joke.joke
        }
        
       let joke = jokeController.publicJokes[indexPath.row]
        
        cell.textLabel?.text = joke.publicJoke
        
        
        return cell
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
