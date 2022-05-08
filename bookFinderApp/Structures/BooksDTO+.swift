//
//  BooksDTO.swift
//  bookFinderApp
//
//  Created by 박지찬 on 2022/05/04.
//

import Foundation

struct BooksDTO: Codable {
    let kind: String
    let totalItems: Int
    let items: [BookItem]
}

struct BookItem: Codable {
    let id: String
    let kind: String
    let etag: String
    let volumeInfo: VolumeInfo
}

struct VolumeInfo: Codable {
    let title: String
    let authors: [String]
    let publishedDate: String
    let maturityRating: String
    let allowAnonLogging: Bool
    let contentVersion: String
    let imageLinks: ImageLinks
    let previewLink: String
    let infoLink: String
    let canonicalVolumeLink: String
}

struct ImageLinks: Codable {
    let smallThumbnail, thumbnail: String
}
