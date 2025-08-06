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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension TaskListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AppData.shared.tasks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // あとでカスタムセルに置き換える予定
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let task = AppData.shared.tasks[indexPath.row]
        cell.textLabel?.text = task.title
        return cell
    }
}
