//
//  GamepassManager.swift
//  Adventura
//
//  Created by Jun on 2023/08/22.
//

import Foundation
import Alamofire

protocol GamepassManagerDelegate{
    func didUpdateGamepass(_ gamepassManager: GamepassManager, gamepassModel: [GamepassModel])
    func didFailWithError(error:Error)
}

struct GamepassManager{
    
    var games = [GamepassModel]()
    
    var delegate: GamepassManagerDelegate?
    
    // fetchGameIDs() function will return all games ID
    func fetchGameIDs(){
        let siglURL = "https://catalog.gamepass.com/sigls/v2?id=29a81209-df6f-41fd-a528-2ae6b91f719c&language=en-us&market=US"
        
        AF.request(siglURL).responseDecodable(of: [GamepassIDsModel].self) { response in
            switch response.result {
            case .success(let gameIDsResponse):
                let gameIDs = gameIDsResponse.compactMap { $0.id }
                self.fetchGameNames(gameIDs: gameIDs)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchGameNames(gameIDs: [String]){
        let idsString = gameIDs.joined(separator: ",")
        let namesURL = "https://displaycatalog.mp.microsoft.com/v7.0/products?bigIds=\(idsString)&market=US&languages=en-us&MS-CV=DGU1mcuYo0WMMp"
        
        performRequest(with: namesURL)
    }
    
    //API Fetcher
    func performRequest(with namesURL: String){
        if let url = URL(string: namesURL){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil{
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data{
                    if let list = self.parseJSON(safeData){
                        self.delegate?.didUpdateGamepass(self, gamepassModel: list)
                    }
                }
            }
            task.resume()
        }
    }
    
    //
    func parseJSON(_ safeData: Data) -> [GamepassModel]?{
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(GamepassData.self, from: safeData)
            let gamesList = decodedData.Products.map { product in
                return GamepassModel(gameTitle: product.LocalizedProperties[0].ProductTitle, gameId: product.ProductId)
            }
            
            return gamesList
        }catch{
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}



