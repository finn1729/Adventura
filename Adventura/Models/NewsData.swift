//
//  NewsData.swift
//  Adventura
//
//  Created by Jun on 2023/08/25.
//

import Foundation

struct NewsData: Codable{
    let results:[News]
}

struct News: Codable{
    let publish_date: String
    let authors: String?
    let title: String?
    let image:Image
    let site_detail_url: String?
}

struct Image: Codable{
    let square_tiny: String?
    let screen_tiny: String?
    let square_small: String?
}

