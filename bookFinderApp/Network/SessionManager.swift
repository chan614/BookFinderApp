//
//  SessionManager.swift
//  bookFinderApp
//
//  Created by 박지찬 on 2022/05/04.
//

import Foundation
import RxSwift

enum NetworkError: Error {
    case notResponse
    case invaildParam
}

final class SessionManager {
    static let shared = SessionManager()
    
    private let session = URLSession.shared
    
    private init() {}
    
    func request<T: Codable>(apiType: APIType) -> Single<T> {
        guard let components = self.urlComponents(apiType: apiType),
              let url = components.url
        else {
            return .error(NetworkError.invaildParam)
        }
        
        return .create { [weak self] single in
            
            self?.session.dataTask(with: url) { data, response, error in
                do {
                    let successRange = 200..<300
                    
                    let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
                    
                    if !successRange.contains(statusCode), let error = error {
                        throw error
                    }
                    
                    guard let data = data else {
                        throw NetworkError.notResponse
                    }
                
                    let model = try JSONDecoder().decode(T.self, from: data)
                    
                    single(.success(model))
                    
                } catch {
                    single(.failure(error))
                }
            }.resume()
            
            return Disposables.create()
        }
    }
    
    private func urlComponents(apiType: APIType) -> URLComponents? {
        var url = apiType.baseURL.appendingPathComponent(apiType.path).absoluteString
        
        let queryItems = apiType.params.map {
            URLQueryItem(name: $0.key, value: String(describing: $0.value))
        }
        
        if !queryItems.isEmpty {
            url += "?"
        }
        
        var components = URLComponents(string: url)
        components?.queryItems?.append(contentsOf: queryItems)
        
        return components
    }
}
