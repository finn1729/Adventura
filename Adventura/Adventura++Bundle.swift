//
//  Adventura++Bundle.swift
//  Adventura
//
//  Created by Jun on 2023/08/25.
//

import Foundation

extension Bundle {
    var apiKey: String {
        guard let file = self.path(forResource: "game", ofType: "plist") else {return ""}
        guard let resource = NSDictionary(contentsOfFile: file) else {return ""}
        guard let key = resource["API_KEY"] as? String else {fatalError("API is not correct")}
        return key
    }
}
