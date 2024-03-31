//
//  NewsManager.swift
//  Adventura
//
//  Created by Jun on 2023/08/25.
//

import Foundation

protocol NewsManagerDelegate{
    func didUpdateGamepass(_ newsManager:NewsManager, newsModel:[NewsModel])
    func didFailWithError(error:Error)
}

struct NewsManager{
    var news = [NewsModel]()
    let apiID = Bundle.main.apiKey
    var delegate: NewsManagerDelegate?

    func fetchNews(){
        let today = Date()
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: today)!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let todayString = dateFormatter.string(from: today)
        let yesterdayString = dateFormatter.string(from: yesterday)
        let dateFilter = "publish_date:\(todayString)|\(todayString)"
        let newsURL = "https://www.gamespot.com/api/articles/?api_key=\(apiID)&format=json&filter=\(dateFilter)"
//        print(newsURL)
//    let newsURL = "https://www.gamespot.com/api/articles/?api_key=40a12bcd959015236f234857e49530bbe568c306&format=json&filter=publish_date:2023-08-30"
        performRequest(with: newsURL)
    }
    
    //API Fetcher
    
    func performRequest(with newsURL: String){
//        print(newsURL)
            if let encodedURL = newsURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
               let url = URL(string: encodedURL) {
                // Use the 'url' here
                let session = URLSession(configuration: .default)
                let task = session.dataTask(with: url) { (data, response, error) in
                    if error != nil{
                        self.delegate?.didFailWithError(error: error!)
                        return
                    }
                    if let safeData = data{
                        if let newsList = self.parseJSON(safeData){
                            self.delegate?.didUpdateGamepass(self, newsModel: newsList)
                        }
                    }
                }
                task.resume()
            } else {
                print("Invalid URL")
            }
//        if let url = URL(string: newsURL){
//            let session = URLSession(configuration: .default)
//            let task = session.dataTask(with: url) { (data, response, error) in
//                if error != nil{
//                    self.delegate?.didFailWithError(error: error!)
//                    return
//                }
//                if let safeData = data{
//                    if let newsList = self.parseJSON(safeData){
//                        self.delegate?.didUpdateGamepass(self, newsModel: newsList)
//                    }
//                }
//            }
//            task.resume()
//        }
    }
    
    //parsing JSON
    func parseJSON(_ safeData: Data) -> [NewsModel]?{
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(NewsData.self, from: safeData)
            let newsList = decodedData.results.map { news in
                return NewsModel(newsTitle: news.title ?? "",
                                 newsImage: news.image.square_tiny ?? "",
                                 newsAuthors: news.authors ?? "",
                                 publishDate: news.publish_date,
                                 siteURL: news.site_detail_url ?? "")

            }
            
            return newsList
        }catch{
            delegate?.didFailWithError(error: error)
            return nil
        }
    }

}
