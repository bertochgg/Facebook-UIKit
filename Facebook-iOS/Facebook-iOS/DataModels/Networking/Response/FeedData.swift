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
    let paging: Paging?
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
    let media: Media?
    let subattachments: Subattachments?
    let target: Target?
    let title: String?
    let url: String?
    let description: String?
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

// MARK: - Subattachments
struct Subattachments: Codable {
    let data: [SubattachmentsDatum]
}

struct SubattachmentsDatum: Codable {
    let media: Media
    let target: Target
    let url: String
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
