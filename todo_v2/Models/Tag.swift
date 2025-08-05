//
//  Tag.swift
//  todo_v2
//
//  Created by ueda yamato on 2025/08/05.
//

import Foundation

struct Tag: Codable, Identifiable, Equatable {
    let id: UUID
    var name: String
    var colorHex: String
    var createdAt: Date

    init(
        id: UUID = UUID(),
        name: String,
        colorHex: String,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.colorHex = colorHex
        self.createdAt = createdAt
    }
}

var tags: [Tag] = []

func addTag(name: String, colorHex: String) {
    let newTag = Tag(name: name, colorHex: colorHex)
    tags.append(newTag)
    StorageManager.shared.saveTags(tags)
}
