//
//  GamepassListViewController.swift
//  Adventura
//
//  Created by Jun on 2023/08/22.
//

import UIKit
import Alamofire

class GamepassListViewController: UITableViewController {
    
    // Display Loading animation
    lazy var activityIndicator: UIActivityIndicatorView = { // Create activityIndicator object only when being called
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.center = view.center // indicator location
        activityIndicator.style = UIActivityIndicatorView.Style.large
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        return activityIndicator
    }()
    
    // Data manager
    var gamepassManager = GamepassManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "gamepassListName")
        self.view.addSubview(activityIndicator) // Add loading animation
        gamepassManager.delegate = self // Assgin delegate to self
        gamepassManager.fetchGameIDs()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gamepassManager.games.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "gamepassListName", for: indexPath)
        let game = gamepassManager.games[indexPath.row]
        cell.textLabel?.text = game.gameTitle
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
//        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        let urlString = "https://www.metacritic.com/search/game/\(gamepassManager.games[indexPath.row].gameURL)/results?search_type=advanced&plats[80000]=1"
        if let url = URL(string: urlString){
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }else{
            print("err")
        }
        
    }
}

//MARK: - GamepassManagerDelegate
extension GamepassListViewController: GamepassManagerDelegate{
    func didUpdateGamepass(_ gamepassManager: GamepassManager, gamepassModel: [GamepassModel]) {
        DispatchQueue.main.async {
            DispatchQueue.main.async {
                // Update the games array in your gamepassManager with the new data
                self.gamepassManager.games = gamepassModel
                
                // Reload the table view to reflect the changes
                self.tableView.reloadData()
                
                // if loading == true, stop animation
                if self.activityIndicator.isAnimating{
                    self.activityIndicator.stopAnimating()
                }
            }
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}
