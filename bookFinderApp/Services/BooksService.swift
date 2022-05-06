//
//  BooksService.swift
//  bookFinderApp
//
//  Created by 박지찬 on 2022/05/05.
//

import Foundation
import RxSwift

protocol BooksServiceable {
    func loadList(term: String, offset: Int, limit: Int) -> Single<BooksDTO>
}

class BooksService: BooksServiceable {
    func loadList(term: String, offset: Int, limit: Int) -> Single<BooksDTO> {
        return .never()
    }
}
