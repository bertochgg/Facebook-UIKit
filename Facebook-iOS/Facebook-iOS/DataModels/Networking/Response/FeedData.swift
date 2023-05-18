//
//  FeedData.swift
//  Facebook-iOS
//
//  Created by Humberto Garcia on 18/05/23.
//

import Foundation

// MARK: - Feed Data
struct FeedData: Codable {
    let data: [FeedDatum]
    let paging: Paging
}

// MARK: - Feed Datum
struct FeedDatum: Codable {
    let message: String?
    let createdTime: Date
    let attachments: Attachments?
    let id: String

    enum CodingKeys: String, CodingKey {
        case message
        case createdTime = "created_time"
        case attachments
        case id
    }
}

// MARK: - Attachments
struct Attachments: Codable {
    let data: [AttachmentsDatum]
}

// MARK: - AttachmentsDatum
struct AttachmentsDatum: Codable {
    let description: String?
    let media: Media?
    let target: Target?
    let type: String?
    let url: URL?
}

// MARK: - Media
struct Media: Codable {
    let image: Image?
}

// MARK: - Image
struct Image: Codable {
    let height: Int?
    let src: URL?
    let width: Int?
}

// MARK: - Target
struct Target: Codable {
    let id: String?
    let url: URL?
}

// MARK: - Paging
struct Paging: Codable {
    let previous: String
    let next: String
}
