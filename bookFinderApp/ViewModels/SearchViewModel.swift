//
//  SearchViewModel.swift
//  bookFinderApp
//
//  Created by 박지찬 on 2022/05/06.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa

class SearchViewModel {
    private let pagingDataSource = BooksPagingDataSource(pagingSize: 30, loadedDistance: 20)
    
    var totalCountObservable: Observable<Int> {
        pagingDataSource.totalCountObservable
    }
    
    var loadingHiddenObservable: Observable<Bool> {
        pagingDataSource
            .loadingStateObservable
            .map { $0 != .loading }
    }
    
    func search(term: String) {
        pagingDataSource.search(term: term)
    }
    
    func listObservable(event: ControlEvent<WillDisplayCellEvent>) -> Observable<[BookListItem]> {
        pagingDataSource.dataSource(event)
    }
}
