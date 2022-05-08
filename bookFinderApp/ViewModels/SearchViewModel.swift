//
//  SearchViewModel.swift
//  bookFinderApp
//
//  Created by 박지찬 on 2022/05/06.
//

import Foundation
import RxSwift
import RxRelay

class SearchViewModel {
    let pagingDataSource = BooksPagingDataSource(pagingSize: 30, loadedDistance: 20)
    
    func search(term: String) {
        pagingDataSource.search(term: term)
        
    }
}
