//
//  NewsFeedVC.swift
//  TopNews
//
//  Created by Joy Banerjee on 09/01/19.
//  Copyright © 2019 Joy Banerjee. All rights reserved.
//

import UIKit

class NewsFeedVC: UITableViewController, UISearchBarDelegate, NetworkRequestHandlerDelegate {

    // MARK: - Properties
    @IBOutlet var topNewsSearchBar: UISearchBar!
    private var news : News?
    private var networkRequestHandler: NetworkRequestHandler?
    private var spinner : UIView?
    let dateFormatter = DateFormatter()
    
    // MARK: - Constants
    let cellReuseIdentifier = "cellIdentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.clearsSelectionOnViewWillAppear = true
        topNewsSearchBar.delegate = self
        
        tableView.register(UINib(nibName: "FeedCell", bundle: nil), forCellReuseIdentifier: "cellIdentifier")
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.backgroundColor = .white
        tableView.refreshControl?.tintColor = .lightGray
        tableView.refreshControl?.addTarget(self, action: #selector(getLatestNews(_:)), for: .valueChanged)
        
        networkRequestHandler = NetworkRequestHandler()
        networkRequestHandler?.delegate = self
        
        //Fetch Top News Feed
        spinner = UIViewController.displaySpinner(onView: self.view)
        networkRequestHandler?.fetchAllNews(for: "us")
        self.title = "Top Headlines (US)"
        self.topNewsSearchBar.text = ""
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        if news?.totalResults != nil {
            self.tableView.separatorStyle = .singleLine
            return 1
        }
        else if spinner == nil {
            let displayMessage = UILabel(frame: CGRect(x: 0, y: 0,
                                                       width: self.view.bounds.width,
                                                       height: self.view.bounds.height))
            displayMessage.textColor = .black
            displayMessage.font = UIFont(name: "Palatino-Italic", size: 15)
            displayMessage.textAlignment = .center
            displayMessage.numberOfLines = 0
            displayMessage.sizeToFit()
            displayMessage.text = "No data is currently available. Please pull down to refresh."
            
            self.tableView.backgroundView = displayMessage
            self.tableView.separatorStyle = .none
        }
        
        return 0;
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news?.articles.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath) as? FeedCell else { return UITableViewCell()}
        
        if let articles = news?.articles {

            let article : Safe<Article> = articles[indexPath.row]
            if let imageUrl = article.value?.urlToImage {
                cell.feedImage.imageFromURL(imageUrl: imageUrl)
            }
            cell.feedTitle?.text = article.value?.title
            cell.feedDescription?.text = article.value?.description
            
            if let publishedAt = article.value?.publishedAt {
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                if let date = dateFormatter.date(from: publishedAt) {
                    cell.timeLapsed?.text = date.timeAgoDisplay()
                }
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let articles = news?.articles {
            let article : Safe<Article> = articles[indexPath.row]
            let detailsVC = NewsDetailsVC(with: article)
            self.navigationController?.pushViewController(detailsVC, animated: true)
        }
    }
    
    //MARK: UISearchbar delegate
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.text = ""
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        makeSearchQuery(with: searchBar.text)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    }
    
    
    private func makeSearchQuery(with searchText: String?) {
        
        guard let searchText = searchText else { return }
        
        //Making Network Request
        spinner = UIViewController.displaySpinner(onView: self.view)
        networkRequestHandler?.makeRequest(with: searchText)
    }
    
    private func stopRefreshControl() {
        
        if let spinner = spinner {
            UIViewController.removeSpinner(spinner: spinner)
        }
        
        DispatchQueue.main.async {
            self.tableView.refreshControl?.endRefreshing()
        }
    }
    
    @objc func getLatestNews(_ refreshControl: UIRefreshControl) {
        self.title = "Top Headlines (US)"
        self.topNewsSearchBar.text = ""
        networkRequestHandler?.fetchAllNews(for: "us")
    }
    
    // MARK: - NetworkRequestHandler delegate
    func gotResults(data: Data) {
        //JSONSerialization
        do {
            let news = try JSONDecoder().decode(News.self, from: data)
            
            self.news = news
            self.stopRefreshControl()
            DispatchQueue.main.async {
                self.tableView.reloadData()
                
                if let text = self.topNewsSearchBar.text, !text.isEmpty {
                    self.title = text+" (\(news.totalResults) Results) "
                }
            }
            print("blog status: \(news.status)")
        }
        catch {
            self.stopRefreshControl()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            print(error.localizedDescription)
        }
    }
    func gotError(error: Error?) {
        stopRefreshControl()
        //Have to Handle the error
        print(error.debugDescription)
    }
}
