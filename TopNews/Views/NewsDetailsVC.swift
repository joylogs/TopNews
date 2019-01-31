//
//  NewsDetailsVC.swift
//  TopNews
//
//  Created by Joy Banerjee on 09/01/19.
//  Copyright © 2019 Joy Banerjee. All rights reserved.
//

import UIKit

class NewsDetailsVC: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet var name: UILabel!
    @IBOutlet var author: UILabel!
    @IBOutlet var url: UILabel!
    @IBOutlet var contentFeed: UILabel!
    @IBOutlet var feedImage: UIImageView!
    
    // MARK: - Properties
    let article: Safe<Article>
    
    // MARK: - Initializer
    init(with articleFeed: Safe<Article>) {
        
        article = articleFeed
        super.init(nibName: "NewsDetailsVC", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = article.value?.title
        
        if let imageUrl = article.value?.urlToImage {
            self.feedImage.imageFromURL(imageUrl: imageUrl)
        }
        self.name.text = article.value?.source.name
        self.author.text = article.value?.author
        self.url.text = article.value?.url?.absoluteString
        self.contentFeed.text = article.value?.description ?? ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
