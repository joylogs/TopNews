//
//  QueryResponse.swift
//  TopNews
//
//  Created by Joy Banerjee on 09/01/19.
//  Copyright © 2019 Joy Banerjee. All rights reserved.
//

import Foundation

struct News: Codable {
    let status: String = ""
    let totalResults: Int32
    let articles: [Safe<Article>]
    
    enum CodingKeys : String, CodingKey {
        case status
        case totalResults
        case articles = "articles"
    }
}

struct Article: Codable {
    
    let source: Source
    let author: String?
    let title: String?
    let description: String?
    let url: URL?
    let urlToImage: URL?
    let publishedAt: String?
    let content: String?
}

struct Source: Codable {
    
    let idParam: String?
    let name: String?
    
    enum CodingKeys : String, CodingKey {
        case idParam = "id"
        case name
    }
}

public struct Safe<Base: Codable>: Codable {
    public let value: Base?
    
    public init(from decoder: Decoder) throws {
        do {
            let container = try decoder.singleValueContainer()
            self.value = try container.decode(Base.self)
        } catch {
//            assertionFailure("ERROR: \(error)")
            self.value = nil
        }
    }
}


fileprivate class SomeFilePrivateClass {        // explicitly file-private class
    func someFilePrivateMethod() {}              // implicitly file-private class member
    public func somePrivateMethod() {}          // explicitly private class member
}

