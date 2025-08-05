//
//  StorageManager.swift
//  todo_v2
//
//  Created by ueda yamato on 2025/08/05.
//

import Foundation

final class StorageManager {
    
    static let shared = StorageManager()

    private let taskKey = "tasks"
    private let tagKey = "tags"

    private init() {}

    // MARK: - 保存
    func saveTasks(_ tasks: [Task]) {
        do {
            let data = try JSONEncoder().encode(tasks)
            UserDefaults.standard.set(data, forKey: taskKey)
        } catch {
            print("❌ タスク保存に失敗しました: \(error)")
        }
    }

    func saveTags(_ tags: [Tag]) {
        do {
            let data = try JSONEncoder().encode(tags)
            UserDefaults.standard.set(data, forKey: tagKey)
        } catch {
            print("❌ タグ保存に失敗しました: \(error)")
        }
    }
    
    // MARK: - 読み込み
    func loadTasks() -> [Task] {
        guard let data = UserDefaults.standard.data(forKey: taskKey) else {
            return []
        }
        do {
            let tasks = try JSONDecoder().decode([Task].self, from: data)
            return tasks
        } catch {
            print("❌ タスク読み込みに失敗しました: \(error)")
            return []
        }
    }

    func loadTags() -> [Tag] {
        guard let data = UserDefaults.standard.data(forKey: tagKey) else {
            return []
        }
        do {
            let tags = try JSONDecoder().decode([Tag].self, from: data)
            return tags
        } catch {
            print("❌ タグ読み込みに失敗しました: \(error)")
            return []
        }
    }

}

