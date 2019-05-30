//
//  PublicJoke.swift
//  DadJokes
//
//  Created by Jeremy Taylor on 5/30/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation

struct PublicJoke: Codable {
    let id: Int?
    let publicJoke: String
}

extension PublicJoke {
    private enum CodingKeys: String, CodingKey {
        case id
        case publicJoke
        
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(publicJoke, forKey: .publicJoke)
        
    }
}
