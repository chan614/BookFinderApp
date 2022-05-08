//
//  PagingDataSource.swift
//  bookFinderApp
//
//  Created by 박지찬 on 2022/05/08.
//

import Foundation
import RxRelay
import RxSwift
import RxCocoa

struct PagingData<Source> {
    let queryOffset: QueryOffset
    let items: [Source]
}

enum PagingLoadingState {
    case loading
    case success
    case error
}

class PagingDataSource<Source> {
    private var disposeBag = DisposeBag()
    private var inProgress = false
    private var currentPosition = 0
    private var queryOffset: QueryOffset
    private var offset = 0
    private var limit = 30
    private var dataList = [Source]() {
        didSet { dataRealy.accept(dataList) }
    }
    private let dataRealy = PublishRelay<[Source]>()
    
    private let pagingSize: Int
    private let loadedDistance: Int
    private let scheduler = SerialDispatchQueueScheduler(qos: .userInitiated)
    
    var count: Int { dataList.count }
    let loadingStateRelay = PublishRelay<PagingLoadingState>()
    
    init(pagingSize: Int, loadedDistance: Int) {
        self.queryOffset = .init(offset: .zero, limit: pagingSize, total: .zero)
        self.pagingSize = pagingSize
        self.loadedDistance = loadedDistance
    }
    
    // MARK: - Final function
    
    final func dataSource(_ event: ControlEvent<WillDisplayCellEvent>) -> Observable<[Source]> {
        event
            .observe(on: ConcurrentDispatchQueueScheduler(qos: .userInitiated))
            .subscribe(with: self, onNext: { owner, event in
                owner.setPosition(event.indexPath.row)
            })
            .disposed(by: disposeBag)
        
        run()
        
        return dataRealy.asObservable()
    }
    
    final func changeDataSource() {
        inProgress = false
        dataList.removeAll()
        
        run()
    }
    
    // MARK: - Override function
    
    func requestRemoteData(offset: Int, limit: Int) -> Single<PagingData<Source>> {
        preconditionFailure("Must be override requestRemoteData")
    }
    
    // MARK: - Private function
    
    private func run() {
        DispatchQueue.global().async {
            if self.count == .zero {
                self.request(isRefresh: true)
            } else {
                self.queryOffset = .init(offset: self.count, limit: self.pagingSize, total: .zero)
            }
        }
    }
    
    private func checkEndDataSource() {
        guard !inProgress else {
            return
        }
        
        let loadedSize = count - loadedDistance
        guard loadedSize <= currentPosition else {
            return
        }
        
        if queryOffset.offset > 1 {
            request(isRefresh: false)
        } else {
            
        }
    }
    
    private func request(isRefresh: Bool) {
        guard !inProgress else {
            return
        }
        
        self.onStart()
        
        let queryOffset = self.queryOffset.current(reset: isRefresh)
        
        if !queryOffset.isMoreAvailable {
            self.onError()
            return
        }
            
        if isRefresh {
            self.dataList.removeAll()
        }
        
        requestRemoteData(
            offset: queryOffset.offset,
            limit: queryOffset.limit)
            .subscribe(on: scheduler)
            .subscribe(
                with: self,
                onSuccess: { owner, data in
                    owner.onSuccess(data)
                },
                onFailure: { owner, error in
                    owner.onError()
                }
            )
            .disposed(by: disposeBag)
         
    }
    
    private func setPosition(_ position: Int) {
        self.currentPosition = position
        self.checkEndDataSource()
    }
    
    private func onSuccess(_ data: PagingData<Source>) {
        queryOffset = data.queryOffset.next()
        dataList.append(contentsOf: data.items)
        loadingStateRelay.accept(.success)
        inProgress = false
    }
    
    private func onError() {
        loadingStateRelay.accept(.error)
        inProgress = false
    }
    
    private func onStart() {
        inProgress = true
        loadingStateRelay.accept(.loading)
        
    }
}

struct QueryOffset {
    let offset: Int
    let limit: Int
    let total: Int
    
    init(offset: Int, limit: Int, total: Int) {
        self.offset = offset
        self.limit = limit
        self.total = total
    }
    
    private init(offset: Int, limit: Int, total: Int, called: Int) {
        self.offset = offset
        self.limit = limit
        self.total = total
        self.called = called
    }
    
    private var called: Int = 0
    
    private var isValid: Bool {
        return offset >= 0 && limit >= 0 && total >= 0
    }
    
    var isMoreAvailable: Bool {
        if !isValid { return false }
        if called == 0 && offset == 0 && total == 0 { return true }
        if called > 0 && total == 0 { return false }
        if total > 0 && offset > (total - 1) { return false }
        return true
    }
    
    func current(reset: Bool = false) -> Self {
        return reset ? Self(offset: 0, limit: limit, total: 0) : self
    }
    
    func next() -> Self {
        let callCount = called + 1
        return Self(offset: offset + limit, limit: limit, total: total, called: callCount)
    }
}
