//
//  AppearanceHelper.swift
//  DadJokes
//
//  Created by Hayden Hastings on 5/28/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

enum AppearanceHelper {
    
    static let dadJokesYellow = UIColor(red: 248 / 255, green: 209 / 255, blue: 77 / 255, alpha: 1)
    static let dadJokesBlue = UIColor(red: 0 / 255, green: 9 / 255, blue: 71 / 255, alpha: 1)
    static let dadJokesGreyishWhite = UIColor(red: 218 / 255, green: 221 / 255, blue: 224 / 255, alpha: 1)
    static let lightBlue = UIColor(red: 127 / 255, green: 203 / 255, blue: 187 / 255, alpha: 1.0)
    static let lightBackgroundColor = UIColor(red: 202 / 255, green: 203 / 255, blue: 207 / 255, alpha: 1.0)
    
    static func setBlueAppearance() {
        UINavigationBar.appearance().barTintColor = dadJokesBlue
        UINavigationBar.appearance().tintColor = dadJokesGreyishWhite
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: dadJokesGreyishWhite]
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: dadJokesGreyishWhite]
    }
}
