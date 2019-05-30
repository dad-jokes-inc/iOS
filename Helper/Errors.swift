//
//  Errors.swift
//  DadJokes
//
//  Created by Jeremy Taylor on 5/28/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation

enum Errors: Error {
    case signupError
    case loginError
    case noDataError
    case authError
    case noTokenError
    case encodingError
    case decodingError
    case noPublicJokesError
    case noJokesError
    case noJokesByUserError
    case noJokeWithProvidedID
    case errorCreatingJoke
    case errorDeletingJoke
    case errorUpdatingJoke
    case unexpectedResponseError
}
