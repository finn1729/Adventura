//
//  NewsModel.swift
//  Adventura
//
//  Created by Jun on 2023/08/25.
//

import Foundation

struct NewsModel{
    var newsTitle: String = ""
    var newsImage: String = ""
    var newsAuthros: String = ""
    var publishDate: String = ""
    var siteURL: String = ""
    
    init(newsTitle: String = "", newsImage: String = "", newsAuthors: String = "", publishDate: String = "", siteURL: String = "") {
        self.newsTitle = newsTitle
        self.newsImage = newsImage
        self.newsAuthros = newsAuthors
        self.publishDate = publishDate
        self.siteURL = siteURL
    }
}


