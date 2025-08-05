
//
//  Untitled.swift
//  todo_v2
//
//  Created by ueda yamato on 2025/08/05.
//

import Foundation

struct Task: Codable, Identifiable, Equatable {
    let id: UUID
    var title: String
    var note: String?
    var dueDate: Date?
    var isCompleted: Bool
    var createdAt: Date
    var updatedAt: Date
    var tagIds: [UUID]

    init(
        id: UUID = UUID(),
        title: String,
        note: String? = nil,
        dueDate: Date? = nil,
        isCompleted: Bool = false,
        createdAt: Date = Date(),
        updatedAt: Date = Date(),
        tagIds: [UUID] = []
    ) {
        self.id = id
        self.title = title
        self.note = note
        self.dueDate = dueDate
        self.isCompleted = isCompleted
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.tagIds = tagIds
    }
}
