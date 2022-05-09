//
//  BooksPagingDataSource.swift
//  bookFinderApp
//
//  Created by 박지찬 on 2022/05/08.
//

import Foundation
import RxSwift

class BooksPagingDataSource: PagingDataSource<BookListItem> {
    private var term = String()
    private let service = BooksService()
    
    func search(term: String) {
        self.term = term
        changeDataSource()
    }
    
    override func requestRemoteData(
        offset: Int,
        limit: Int
    ) -> Single<PagingData<BookListItem>> {
        
        if term.isEmpty {
            return .just(.init(
                queryOffset: .init(offset: .zero, limit: limit, total: .zero),
                items: []))
        }
        
        return service
            .loadList(term: term, offset: offset, limit: limit)
            .map { [weak self] in
                return .init(
                    queryOffset: .init(offset: offset, limit: limit, total: $0.totalItems),
                    items: self?.toBookListItems(from: $0.items) ?? [])
            }
    }
    
    private func toBookListItems(from bookItems: [BookItem]) -> [BookListItem] {
        bookItems.map {
            var author = String()
            for authorStr in $0.volumeInfo.authors ?? [] {
                if !authorStr.isEmpty {
                    author = authorStr
                    break
                }
            }
            
            return .init(
                title: $0.volumeInfo.title ?? String(),
                author: author,
                date: $0.volumeInfo.publishedDate ?? String(),
                thumbnailURL: URL(string: $0.volumeInfo.imageLinks?.thumbnail ?? String()),
                infoURL: URL(string: $0.volumeInfo.infoLink))
        }
    }
    
    
}
