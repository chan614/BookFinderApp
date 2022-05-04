//
//  APIType.swift
//  bookFinderApp
//
//  Created by 박지찬 on 2022/05/03.
//

import Foundation

protocol APIType {
    var baseURL: URL { get }
    var path: String { get }
    var params: [String: Any] { get }
}
