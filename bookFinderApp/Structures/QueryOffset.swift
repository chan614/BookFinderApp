//
//  QueryOffset.swift
//  bookFinderApp
//
//  Created by 박지찬 on 2022/05/09.
//

import Foundation

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
