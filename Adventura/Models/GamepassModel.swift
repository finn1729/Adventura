//
//  GamepassModel.swift
//  Adventura
//
//  Created by Jun on 2023/08/22.
//

import Foundation

struct GamepassModel{
    let gameTitle: String
    let gameId: String
    var gameURL: String{
        get {
            return gameTitle.replacingOccurrences(of: " ", with: "%20")
        }
    }
    
    init(gameTitle: String = "", gameId: String = "") {
        self.gameTitle = gameTitle
        self.gameId = gameId
    }
}

