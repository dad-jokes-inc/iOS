//
//  JokeController.swift
//  DadJokes
//
//  Created by Jeremy Taylor on 5/28/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation

class JokeController {
    static let shared = JokeController()
    
    init() {
        loadFromPersistentStore()
    }
    enum HTTPMethod: String {
        case get = "GET"
        case put = "PUT"
        case post = "POST"
        case delete = "DELETE"
    }
    
    var publicJokes: [PublicJoke] = []
    
    var jokes: [Joke] = []
    var publicUserJokes: [PublicJoke] = []
    
    
    var bearer: Bearer?
    var user: User?
    
    private let baseURL = URL(string: "https://dad-jokes-buildweek.herokuapp.com/api")!
    
    //MARK: - Register
    
    
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
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
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
            
            guard let data = data else {
                completion(Errors.noDataError)
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let user = try decoder.decode(User.self, from: data)
                self.user = user
                print(user.id)
                self.saveToPersistentStore()
                
            } catch {
                NSLog("Error decoding user")
                completion(Errors.decodingError)
            }
            
            completion(nil)
            }.resume()
        
    }
    
    //MARK: - Login
    
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
    
    //MARK: - Fetch Public Jokes
    
    func fetchPublicJokes(completion: @escaping (Error?) -> Void) {
        let requestURL = baseURL
            .appendingPathComponent("public")
        
        var request = URLRequest(url: requestURL)
        
        request.httpMethod = HTTPMethod.get.rawValue
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                NSLog("Error getting public jokes: \(error)")
                completion(Errors.noPublicJokesError)
                return
            }
            
            guard let data = data else {
                NSLog("No data returned: \(String(describing: error))")
                completion(Errors.noDataError)
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                self.publicJokes = try decoder.decode([PublicJoke].self, from: data)
                completion(nil)
            } catch {
                NSLog("Error decoding jokes: \(error)")
                completion(Errors.decodingError)
            }
            }.resume()
    }
    
    //MARK: - Fetch Jokes
    
    func fetchAllJokes(completion: @escaping (Error?) -> Void) {
        
        let requestURL = baseURL
            .appendingPathComponent("jokes")
        
        var request = URLRequest(url: requestURL)
        
        request.httpMethod = HTTPMethod.get.rawValue
        
                guard let bearer = bearer else {
                    completion(Errors.noTokenError)
                    return
                }
        
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
    
    //MARK: - Fetch a specific users jokes
    
    func fetchJokesByUser(withID userID: Int, completion: @escaping (Error?) -> Void) {
        let requestURL = baseURL
            .appendingPathComponent("jokes").appendingPathComponent("users").appendingPathComponent(String("\(userID)"))
        
        var request = URLRequest(url: requestURL)
        
        request.httpMethod = HTTPMethod.get.rawValue
        
        guard let bearer = bearer else {
            completion(Errors.noTokenError)
            return
        }
        
        request.addValue("\(bearer.token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let response = response as? HTTPURLResponse,
                response.statusCode == 401 {
                NSLog("Bad auth: \(String(describing: error))")
                completion(Errors.authError)
                return
            }
            
            if let error = error {
                NSLog("Error getting users jokes: \(error)")
                completion(Errors.noJokesByUserError)
                return
            }
            
            guard let data = data else {
                NSLog("No data returned: \(String(describing: error))")
                completion(Errors.noDataError)
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                
                completion(nil)
            } catch {
                NSLog("Error decoding jokes: \(error)")
                completion(Errors.decodingError)
            }
            }.resume()
        
    }
    
    //MARK - Fetch Joke with Joke ID
    
    func fetchJoke(withID jokeID: Int, completion: @escaping (Error?) -> Void) {
        let requestURL = baseURL
            .appendingPathComponent("jokes").appendingPathComponent(String("\(jokeID)"))
        
        var request = URLRequest(url: requestURL)
        
        request.httpMethod = HTTPMethod.get.rawValue
        
        guard let bearer = bearer else {
            completion(Errors.noTokenError)
            return
        }
        
        request.addValue("\(bearer.token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let response = response as? HTTPURLResponse,
                response.statusCode == 401 {
                NSLog("Bad auth: \(String(describing: error))")
                completion(Errors.authError)
                return
            }
            
            if let error = error {
                NSLog("Error getting users jokes: \(error)")
                completion(Errors.noJokeWithProvidedID)
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
    
    //MARK: - Create Public Joke
    
    func createPublicJoke(jokeContent: String, completion: @escaping (Error?) -> Void) {
        let requestURL = baseURL.appendingPathComponent("public")
        
        var request = URLRequest(url: requestURL)
        
        request.httpMethod = HTTPMethod.post.rawValue
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let publicJoke = PublicJoke(id: nil, publicJoke: jokeContent)
        
        do {
            request.httpBody = try JSONEncoder().encode(publicJoke)
        } catch {
            NSLog("Error encoding Joke: \(error)")
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
                NSLog("Error creating joke: \(error)")
                completion(Errors.errorCreatingPublicJoke)
                return
            }
            
            completion(nil)
            }.resume()
        
    }
    
    
    //MARK: - Create Joke
    
    func createJoke(userID: Int, jokeContent: String, completion: @escaping (Error?) -> Void) {
        
        let requestURL = baseURL.appendingPathComponent("jokes")
        print(requestURL)
        
        var request = URLRequest(url: requestURL)
        
        request.httpMethod = HTTPMethod.post.rawValue
        
                guard let bearer = bearer else {
                    completion(Errors.noTokenError)
                    return
                }
        
        
        request.addValue("\(bearer.token)", forHTTPHeaderField: "Authorization")
        
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let joke = Joke(id: nil, joke: jokeContent, userID: userID, userName: nil)
        
        do {
            request.httpBody = try JSONEncoder().encode(joke)
        } catch {
            NSLog("Error encoding Joke: \(error)")
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
                NSLog("Error creating joke: \(error)")
                completion(Errors.errorCreatingJoke)
                return
            }
            
            completion(nil)
            }.resume()
        
    }
    
    //MARK: - Delete Private Joke
    
    func deletePrivateJoke(jokeID: Int, completion: @escaping (Error?) -> Void) {
        
        let requestURL = baseURL.appendingPathComponent("jokes").appendingPathComponent(String(jokeID))
        
        var request = URLRequest(url: requestURL)
        
        request.httpMethod = HTTPMethod.delete.rawValue
        
                guard let bearer = bearer else {
                    completion(Errors.noTokenError)
                    return
                }
        
        request.addValue("\(bearer.token)", forHTTPHeaderField: "Authorization")
        
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        
        URLSession.shared.dataTask(with: request) { (_, response, error) in
            
            if let response = response as? HTTPURLResponse,
                response.statusCode != 204 {
                
                // Something went wrong
                completion(Errors.unexpectedResponseError)
                return
            }
            
            if let error = error {
                NSLog("Error deleting joke: \(error)")
                completion(Errors.errorDeletingJoke)
                return
            }
            
            completion(nil)
            }.resume()
        
    }
    
    //MARK: - Update joke
    
    func updateJoke(jokeID: Int, jokeContent: String, userID: Int, completion: @escaping (Error?) -> Void) {
        let requestURL = baseURL.appendingPathComponent("jokes").appendingPathComponent(String(jokeID))
        
        print(requestURL)
        
        var request = URLRequest(url: requestURL)
        
        request.httpMethod = HTTPMethod.put.rawValue
        
                guard let bearer = bearer else {
                    completion(Errors.noTokenError)
                    return
                }
        
        request.addValue("\(bearer.token)", forHTTPHeaderField: "Authorization")
        
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let joke = Joke(id: jokeID, joke: jokeContent, userID: userID, userName: nil)
        
        do {
            request.httpBody = try JSONEncoder().encode(joke)
        } catch {
            NSLog("Error encoding Joke: \(error)")
            completion(Errors.encodingError)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (_, response, error) in
            
            if let error = error {
                NSLog("Error updating joke: \(error)")
                completion(Errors.errorUpdatingJoke)
                return
            }
            
            completion(nil)
            }.resume()
    }
    
    // MARK: - Persistance
    
    private var persistentFileURL: URL? {
        let fm = FileManager.default
        
        guard let documentsDirectory = fm.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        
        return documentsDirectory.appendingPathComponent("DadJokes.plist")
    }
    
    func saveToPersistentStore() {
        guard let url = persistentFileURL else { return }
        
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(user)
            try data.write(to: url)
        } catch {
            NSLog("Couldn't save user data: \(error)")
        }
    }
    
    func loadFromPersistentStore() {
        do {
            let fm = FileManager.default
            guard let url = persistentFileURL, fm.fileExists(atPath: url.path) else { return }
            let data = try Data(contentsOf: url)
            let decoder = PropertyListDecoder()
            let decodedUser = try decoder.decode(User.self, from: data)
            self.user = decodedUser
        } catch {
            NSLog("Couldn't load user data: \(error)")
        }
    }
}
