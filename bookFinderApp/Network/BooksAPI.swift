//
//  BooksAPI.swift
//  bookFinderApp
//
//  Created by 박지찬 on 2022/05/03.
//

import Foundation

enum BooksAPI: APIType {
    case list(term: String, offset: Int, limit: Int)
}

extension BooksAPI {
    var baseURL: URL {
        URL(string: "https://www.googleapis.com/books/v1/")!
    }
    
    var path: String {
        switch self {
        case .list:
            return "volumes"
        }
    }
    
    var params: [String: Any] {
        switch self {
        case let .list(term, offset, limit):
            return [
                "q": term,
                "maxResults": limit,
                "startIndex": offset
            ]
        }
    }

}
