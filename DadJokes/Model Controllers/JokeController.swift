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
    
    private let baseURL = URL(string: "https://dad-jokes-buildweek.herokuapp.com/api")!
    
    var bearer: Bearer?
    
    
    
    
    func createUser(name: String, password: String, completion: @escaping (Error?) -> Void) {
        
        let requestURL = baseURL.appendingPathComponent("register")
        print(requestURL)
        
        var request = URLRequest(url: requestURL)
        
        request.httpMethod = HTTPMethod.post.rawValue
        
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let user = User(id: nil, username: name, password: password)
        
        do {
            request.httpBody = try JSONEncoder().encode(user)
        } catch {
            NSLog("Error encoding User: \(error)")
            completion(Errors.encodingError)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (_, response, error) in
            
            if let response = response as? HTTPURLResponse,
                response.statusCode != 201 {
                
                // Something went wrong
                completion(Errors.unexpectedResponseError)
                return
            }
            
            if let error = error {
                NSLog("Error signing up: \(error)")
                completion(Errors.signupError)
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
            completion(Errors.encodingError)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                
                // Something went wrong
                completion(Errors.unexpectedResponseError)
                return
            }
            
            if let error = error {
                NSLog("Error logging in: \(error)")
                completion(Errors.loginError)
                return
            }
            
            // Get the bearer token by decoding it.
            
            guard let data = data else {
                NSLog("No data returned from data task")
                completion(Errors.noDataError)
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                let bearer = try decoder.decode(Bearer.self, from: data)
                
                // We now have the bearer to authenticate the other requests
                self.bearer = bearer
                completion(nil)
            } catch {
                NSLog("Error decoding Bearer: \(error)")
                completion(Errors.noTokenError)
                return
            }
            }.resume()
    }
    
    func fetchAllJokes(completion: @escaping (Error?) -> Void) {
       
        guard let bearer = bearer else {
            NSLog("No bearer token available")
            completion(Errors.noTokenError)
            return
        }
        
        let requestURL = baseURL
            .appendingPathComponent("jokes")
        
        var request = URLRequest(url: requestURL)
        
        request.httpMethod = HTTPMethod.get.rawValue
        
        // This is our method of authenticating with the API.
        request.addValue("\(bearer.token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let response = response as? HTTPURLResponse,
                response.statusCode == 401 {
                NSLog("Bad auth: \(String(describing: error))")
                completion(Errors.authError)
                return
            }
            
            if let error = error {
                NSLog("Error getting jokes: \(error)")
                completion(Errors.noJokesError)
                return
            }
            
            guard let data = data else {
                NSLog("No data returned: \(String(describing: error))")
                completion(Errors.noDataError)
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                self.jokes = try decoder.decode([Joke].self, from: data)
                completion(nil)
            } catch {
                NSLog("Error decoding jokes: \(error)")
                completion(Errors.decodingError)
            }
            }.resume()
    }
}
