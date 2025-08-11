//
//  TaskListViewController.swift
//  todo_v2
//
//  Created by ueda yamato on 2025/08/06.
//

import Foundation
import UIKit

enum SortOption: CaseIterable {
    case createdAtAsc, createdAtDesc, dueDateAsc, dueDateDesc
    
    var displayName: String {
        switch self {
        case .createdAtAsc: return "作成日（古い順）"
        case .createdAtDesc: return "作成日（新しい順）"
        case .dueDateAsc: return "期限（近い順）"
        case .dueDateDesc: return "期限（遠い順）"
        }
    }
    
    var iconName: String {
        switch self {
        case .createdAtAsc: return "calendar.badge.plus"
        case .createdAtDesc: return "calendar.badge.plus"
        case .dueDateAsc: return "clock"
        case .dueDateDesc: return "clock"
        }
    }
}

class TaskListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    // ソート状態管理
    private var currentSortOption: SortOption = .createdAtDesc
    private var sortedTasks: [Task] = []
    
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
        
        // ナビゲーションバーにソートボタンを追加
        setupNavigationBar()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(taskAdded),
            name: NSNotification.Name("TaskAdded"),
            object: nil
        )
        
        // 初回ソート実行
        sortTasks()
        updateEmptyState()
    }
    
    private func setupNavigationBar() {
        let sortButton = UIBarButtonItem(
            image: UIImage(systemName: "arrow.up.arrow.down"),
            style: .plain,
            target: self,
            action: #selector(sortButtonTapped)
        )
        navigationItem.leftBarButtonItem = sortButton
        
        // タイトルにソート状態を表示
        updateNavigationTitle()
    }
    
    private func updateNavigationTitle() {
        title = "タスク一覧 (\(currentSortOption.displayName))"
    }
    
    @objc private func taskAdded() {
        sortTasks() // ソート済みリストを更新
        tableView.reloadData()
        updateEmptyState()
    }
    
    @objc private func sortButtonTapped() {
        let actionSheet = UIAlertController(title: "ソート方法を選択", message: nil, preferredStyle: .actionSheet)
        
        for option in SortOption.allCases {
            let action = UIAlertAction(title: option.displayName, style: .default) { [weak self] _ in
                self?.currentSortOption = option
                self?.sortTasks()
                self?.updateNavigationTitle()
                self?.tableView.reloadData()
            }
            
            // 現在選択中のオプションにチェックマークを付ける
            if option == currentSortOption {
                action.setValue(true, forKey: "checked")
            }
            
            actionSheet.addAction(action)
        }
        
        actionSheet.addAction(UIAlertAction(title: "キャンセル", style: .cancel))
        
        // iPadでのpopover設定
        if let popover = actionSheet.popoverPresentationController {
            popover.barButtonItem = navigationItem.leftBarButtonItem
        }
        
        present(actionSheet, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sortTasks()
        tableView.reloadData()
        updateEmptyState()
    }
    
    // MARK: - ソート機能
    private func sortTasks() {
        switch currentSortOption {
        case .createdAtAsc:
            sortedTasks = AppData.shared.tasks.sorted { $0.createdAt < $1.createdAt }
        case .createdAtDesc:
            sortedTasks = AppData.shared.tasks.sorted { $0.createdAt > $1.createdAt }
        case .dueDateAsc:
            sortedTasks = AppData.shared.tasks.sorted { task1, task2 in
                // 期限なしは最後に配置
                guard let date1 = task1.dueDate else { return false }
                guard let date2 = task2.dueDate else { return true }
                return date1 < date2
            }
        case .dueDateDesc:
            sortedTasks = AppData.shared.tasks.sorted { task1, task2 in
                // 期限なしは最後に配置
                guard let date1 = task1.dueDate else { return false }
                guard let date2 = task2.dueDate else { return true }
                return date1 > date2
            }
        }
    }
    
    // タスクが0件のときは「タスクはありません」と表示
    private func updateEmptyState() {
        if AppData.shared.tasks.isEmpty {
            let emptyView = UIView()
            let label = UILabel()
            label.text = "タスクはありません"
            label.textAlignment = .center
            label.textColor = UIColor.secondaryLabel
            label.font = UIFont.systemFont(ofSize: 18)
            
            emptyView.addSubview(label)
            label.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                label.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor),
                label.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor)
            ])
            
            tableView.backgroundView = emptyView
        } else {
            tableView.backgroundView = nil
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension TaskListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedTasks.count
    }

    // セルの中身
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let task = sortedTasks[indexPath.row]
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
            let task = sortedTasks[indexPath.row]
            
            let alert = UIAlertController(title: "削除確認", message: "「\(task.title)」を削除しますか？", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "削除", style: .destructive) { [weak self] _ in
                // sortedTasksから元のインデックスを見つけて削除
                if let originalIndex = AppData.shared.tasks.firstIndex(where: { $0.id == task.id }) {
                    AppData.shared.tasks.remove(at: originalIndex)
                    AppData.shared.saveAll()
                    self?.sortTasks()
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    self?.updateEmptyState()
                }
            })
            
            alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel))
            present(alert, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let task = sortedTasks[indexPath.row]
        let title = task.isCompleted ? "未完了" : "完了"
        let backgroundColor: UIColor = task.isCompleted ? .systemOrange : .systemGreen
        
        let toggleAction = UIContextualAction(style: .normal, title: title) { [weak self] (_, _, completionHandler) in
            // sortedTasksから元のインデックスを見つけて更新
            if let originalIndex = AppData.shared.tasks.firstIndex(where: { $0.id == task.id }) {
                AppData.shared.tasks[originalIndex].isCompleted.toggle()
                AppData.shared.tasks[originalIndex].updatedAt = Date()
                AppData.shared.saveAll()
                
                self?.sortTasks()
                tableView.reloadRows(at: [indexPath], with: .none)
            }
            completionHandler(true)
        }
        
        toggleAction.backgroundColor = backgroundColor
        
        let configuration = UISwipeActionsConfiguration(actions: [toggleAction])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // TaskDetail.storyboardから詳細画面をインスタンス化
        let storyboard = UIStoryboard(name: "TaskDetail", bundle: nil)
        guard let detailVC = storyboard.instantiateViewController(withIdentifier: "TaskDetailViewController") as? TaskDetailViewController else {
            print("TaskDetailViewController のインスタンス化に失敗しました")
            return
        }
        
        // sortedTasksから元のインデックスを見つけてタスクデータを受け渡し
        let task = sortedTasks[indexPath.row]
        guard let originalIndex = AppData.shared.tasks.firstIndex(where: { $0.id == task.id }) else {
            print("元のタスクインデックスが見つかりません")
            return
        }
        
        detailVC.task = task
        detailVC.taskIndex = originalIndex
        
        // 更新通知のコールバックを設定
        detailVC.onTaskUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.sortTasks()
                self?.tableView.reloadData()
                self?.updateEmptyState()
            }
        }
        
        // ナビゲーションでプッシュ遷移
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
