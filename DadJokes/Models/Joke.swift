//
//  Joke.swift
//  DadJokes
//
//  Created by Hayden Hastings on 5/29/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation

import Foundation


struct Joke: Codable {
    let id: Int
    var joke: String
    var userID: Int
}

extension Joke {
    private enum CodingKeys: String, CodingKey {
        case id
        case joke
        case userID = "user_id"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(joke, forKey: .joke)
        try container.encode(userID, forKey: .userID)
    }
}
