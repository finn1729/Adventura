//
//  GamepassModel.swift
//  Adventura
//
//  Created by Jun on 2023/08/22.
//

import Foundation

struct GamepassData: Codable{
    let Products:[Game]
}

struct Game: Codable, Identifiable{
    var id: String{
        return ProductId
    }
    let LocalizedProperties: [LocalizedProperties]
    let ProductId: String
}

struct LocalizedProperties: Codable{
    let ProductTitle: String
    let SupportUri: String
}
