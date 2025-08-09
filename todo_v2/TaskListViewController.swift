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
        content.text = task.title
        
        if let dueDate = task.dueDate {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "ja_JP")
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            content.secondaryText = formatter.string(from: dueDate)
        } else {
            content.secondaryText = "期限なし"
        }
        
        cell.contentConfiguration = content
        return cell
    }
}
