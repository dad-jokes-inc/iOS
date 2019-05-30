//
//  User.swift
//  DadJokes
//
//  Created by Jeremy Taylor on 5/28/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation

struct User: Codable {
    let id: Int?
    let username: String
    let password: String
}

extension User {
    
    private enum CodingKeys: String, CodingKey {
        case username
        case password
        case id
        
        
    }
    
    init (from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        username = try values.decode(String.self, forKey: .username)
        password = try values.decode(String.self, forKey: .password)
        
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(username, forKey: .username)
        try container.encode(password, forKey: .password)
        try container.encodeIfPresent(id, forKey: .id)
    }
}
