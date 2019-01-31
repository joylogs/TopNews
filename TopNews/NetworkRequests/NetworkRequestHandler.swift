//
//  NetworkRequestHandler.swift
//  TopNews
//
//  Created by Joy Banerjee on 09/01/19.
//  Copyright © 2019 Joy Banerjee. All rights reserved.
//

import Foundation

protocol NetworkRequestHandlerDelegate: class {
    
    func gotResults(data: Data)
    func gotError(error: Error?)
}


class NetworkRequestHandler {
    
    // MARK: - Constants
    let apiKey = "7d893cd1b7c74014942756a362d72c9f"
    let apiHost = "https://newsapi.org"
    
    weak var delegate: NetworkRequestHandlerDelegate?
    
    func makeRequest(with query: String) {
        
        let urlString = URL(string: "\(apiHost)/v2/everything?q=\(query)&apiKey=\(apiKey)")
        
        if let url = urlString {
            let task = URLSession.shared.dataTask(with: url) { [unowned self] (data, response, error) in
                if error != nil {
                    print(error.debugDescription)
                    self.delegate?.gotError(error: error)
                } else {
                    if let usableData = data {
//                        print(usableData)
                        //Success:
                        self.delegate?.gotResults(data: usableData)
                    }
                }
            }
            task.resume()
        }
    }
    
    func fetchAllNews(for country: String) {
        
        let urlString = URL(string: "\(apiHost)/v2/top-headlines?country=\(country)&apiKey=\(apiKey)")
        
        if let url = urlString {
            let task = URLSession.shared.dataTask(with: url) { [unowned self] (data, response, error) in
                if error != nil {
                    print(error.debugDescription)
                    self.delegate?.gotError(error: error)
                } else {
                    if let usableData = data {
//                        print(usableData)
                        //Success:
                        self.delegate?.gotResults(data: usableData)
                    }
                }
            }
            task.resume()
        }
    }
}
