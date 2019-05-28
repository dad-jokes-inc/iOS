//
//  JokeController.swift
//  DadJokes
//
//  Created by Jeremy Taylor on 5/28/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation

class JokeController {
    enum HTTPMethod: String {
        case get = "GET"
        case put = "PUT"
        case post = "POST"
        case delete = "DELETE"
    }
    var jokes: [Joke] = []
    
    private let baseURL = URL(string: "https://someurl.com")!
    
    func createUser(name: String, password: String, completion: @escaping (Error?) -> Void) {
        
        let requestURL = baseURL.appendingPathComponent("login/signup")
        
        var request = URLRequest(url: requestURL)
        
        request.httpMethod = HTTPMethod.post.rawValue
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let user = User(id: nil, username: name, password: password)
        
        do {
            request.httpBody = try JSONEncoder().encode(user)
        } catch {
            NSLog("Error encoding User: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (_, response, error) in
            
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                
                // Something went wrong
                completion(NSError())
                return
            }
            
            if let error = error {
                NSLog("Error signing up: \(error)")
                completion(error)
                return
            }
            
            completion(nil)
            }.resume()
        
    }
    
    func logIn(with username: String, password: String, completion: @escaping (Error?) -> Void) {
        
        let requestURL = baseURL.appendingPathComponent("login")
        
        var request = URLRequest(url: requestURL)
        
        request.httpMethod = HTTPMethod.post.rawValue
        
        // The body of our request is JSON.
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let user = User(id: nil, username: username, password: password)
        
        do {
            request.httpBody = try JSONEncoder().encode(user)
        } catch {
            NSLog("Error encoding User: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                
                // Something went wrong
                completion(NSError())
                return
            }
            
            if let error = error {
                NSLog("Error logging in: \(error)")
                completion(error)
                return
            }
            
            
            }.resume()
    }
    
    func fetchAllJokes(completion: @escaping (Error?) -> Void) {
        let requestURL = baseURL
            .appendingPathComponent("jokes")
        
        var request = URLRequest(url: requestURL)
        
        request.httpMethod = HTTPMethod.get.rawValue
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                NSLog("Error getting jokes: \(error)")
                completion(error)
                return
            }
            
            guard let data = data else {
                NSLog("No data returned: \(error)")
                completion(error)
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                self.jokes = try decoder.decode([Joke].self, from: data)
                completion(nil)
            } catch {
                NSLog("Error decoding gigs: \(error)")
                completion(error)
            }
            }.resume()
    }
    
    func createJoke(joke: Joke, completion: @escaping (Error?) -> Void) {
        let requestURL = baseURL
            .appendingPathComponent("jokes")
        
        var request = URLRequest(url: requestURL)
        
        request.httpMethod = HTTPMethod.post.rawValue
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonEncoder = JSONEncoder()
            request.httpBody = try jsonEncoder.encode(joke)
        } catch {
            NSLog("Error encoding joke: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (_, response, error) in
            
            if let error = error {
                completion(error)
                return
            }
            
            self.jokes.append(joke)
            }.resume()
        
    }
}
