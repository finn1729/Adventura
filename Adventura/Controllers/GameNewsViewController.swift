//
//  ViewController.swift
//  Adventura
//
//  Created by Jun on 2023/08/22.
//

import UIKit

class GameNewsViewController: UIViewController {
    
    @IBOutlet weak var newsTableViewOutlet: UITableView!
    
    var newsManager = NewsManager()
    var numOfFetch = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newsTableViewOutlet.delegate = self
        newsTableViewOutlet.dataSource = self
        newsManager.delegate = self
        newsManager.fetchNews()
        
        newsTableViewOutlet.register(UINib(nibName: "NewsCell", bundle: nil),forCellReuseIdentifier: "ReusableCell")
    }



}

extension GameNewsViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsManager.news.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! NewsCell
        let newsItem = newsManager.news[indexPath.row]
        if newsManager.news.count > 0{
            cell.labelOutlet.text = newsItem.newsTitle
//            cell.labelOutlet?.text = newsItem.newsTitle
//            cell.textLabel?.text = newsItem.newsTitle
        }
        
        if let imageURL = URL(string: newsItem.newsImage) {
            URLSession.shared.dataTask(with: imageURL) { data, response, error in
                if let error = error {
                    print("Error loading image: \(error)")
                    return
                }

                if let imageData = data {
                    DispatchQueue.main.async {
                        cell.imageOutlet.image = UIImage(data: imageData)
                    }
                }
            }.resume()
        }
        
        return cell
    }
    
}

//MARK: - NewsManager Delegate
extension GameNewsViewController: NewsManagerDelegate{
    func didUpdateGamepass(_ newsManager: NewsManager, newsModel: [NewsModel]) {
        
        DispatchQueue.main.async {
            // Update the games array in your gamepassManager with the new data
            self.newsManager.news = newsModel
            
            // Reload the table view to reflect the changes
            self.newsTableViewOutlet.reloadData()
            
        }
    }
    
    func didFailWithError(error: Error) {
        if numOfFetch <= 3 {
            print("\(numOfFetch) Fetch(): Failed and try fetch again")
            numOfFetch += 1
            newsManager.fetchNews()
        } else{
            print(error)
        }
    }
}

//MARK: - TableView delegate
extension GameNewsViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

