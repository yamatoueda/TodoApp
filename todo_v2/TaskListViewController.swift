//
//  TaskListViewController.swift
//  todo_v2
//
//  Created by ueda yamato on 2025/08/06.
//

import Foundation
import UIKit

class TaskListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        // StoryboardからAddTaskViewControllerをインスタンス化
        let storyboard = UIStoryboard(name: "AddTask", bundle: nil)
        let addVC = storyboard.instantiateViewController(withIdentifier: "AddTaskViewController")
        
        // 半モーダルで表示
        addVC.modalPresentationStyle = .pageSheet
        if let sheet = addVC.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.preferredCornerRadius = 20
        }
        present(addVC, animated: true, completion: nil)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(taskAdded),
            name: NSNotification.Name("TaskAdded"),
            object: nil
        )
    }
    
    @objc private func taskAdded() {
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension TaskListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AppData.shared.tasks.count
    }

    // セルの中身
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let task = AppData.shared.tasks[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        
        // 完了済みの場合はタイトルに取り消し線を追加
        if task.isCompleted {
            let attributedText = NSAttributedString(
                string: task.title,
                attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue,
                           .foregroundColor: UIColor.secondaryLabel]
            )
            content.attributedText = attributedText
        } else {
            content.text = task.title
        }
        
        // 期限とステータスを表示
        var secondaryTextParts: [String] = []
        
        if let dueDate = task.dueDate {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "ja_JP")
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            secondaryTextParts.append(formatter.string(from: dueDate))
        } else {
            secondaryTextParts.append("期限なし")
        }
        
        secondaryTextParts.append(task.isCompleted ? "✅ 完了" : "⏳ 未完了")
        content.secondaryText = secondaryTextParts.joined(separator: " • ")
        
        cell.contentConfiguration = content
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let task = AppData.shared.tasks[indexPath.row]
            
            let alert = UIAlertController(title: "削除確認", message: "「\(task.title)」を削除しますか？", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "削除", style: .destructive) { _ in
                AppData.shared.tasks.remove(at: indexPath.row)
                AppData.shared.saveAll()
                tableView.deleteRows(at: [indexPath], with: .fade)
            })
            
            alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel))
            present(alert, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let task = AppData.shared.tasks[indexPath.row]
        let title = task.isCompleted ? "未完了" : "完了"
        let backgroundColor: UIColor = task.isCompleted ? .systemOrange : .systemGreen
        
        let toggleAction = UIContextualAction(style: .normal, title: title) { [weak self] (_, _, completionHandler) in
            AppData.shared.tasks[indexPath.row].isCompleted.toggle()
            AppData.shared.tasks[indexPath.row].updatedAt = Date()
            AppData.shared.saveAll()
            
            tableView.reloadRows(at: [indexPath], with: .none)
            completionHandler(true)
        }
        
        toggleAction.backgroundColor = backgroundColor
        
        let configuration = UISwipeActionsConfiguration(actions: [toggleAction])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }
}
