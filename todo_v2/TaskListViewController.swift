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
        
        // モーダルで表示
        addVC.modalPresentationStyle = .fullScreen
        present(addVC, animated: true, completion: nil)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
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
        cell.contentConfiguration = content
        return cell
    }
}
