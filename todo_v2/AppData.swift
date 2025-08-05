//
//  AppData.swift
//  todo_v2
//
//  Created by ueda yamato on 2025/08/05.
//

import Foundation

final class AppData {
    static let shared = AppData()
    
    private init() {
        loadAll()
    }
    
    var tasks: [Task] = []
    var tags: [Tag] = []
    
    func loadAll() {
        tasks = StorageManager.shared.loadTasks()
        tags = StorageManager.shared.loadTags()
    }
    
    func saveAll() {
        StorageManager.shared.saveTasks(tasks)
        StorageManager.shared.saveTags(tags)
    }
}
