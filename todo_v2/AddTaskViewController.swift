//
//  AddTaskViewController.swift
//  todo_v2
//
//  Created by ueda yamato on 2025/08/07.
//

import UIKit

class AddTaskViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var saveButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // モダールから戻ったあとの挙動書く
        // tableView.reloadData()
    }

    
    @IBAction func saveButtonTapped(_ sender: Any) {
        // 入力内容を取得して Task を作成
        guard let title = titleTextField.text, !title.isEmpty else {
            // 例えばアラートで警告
            let alert = UIAlertController(title: "エラー", message: "タイトルを入力してください", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }

        let dueDate = datePicker.date

        let task = Task(title: title, dueDate: dueDate)

        AppData.shared.tasks.append(task)
        AppData.shared.saveAll()

        dismiss(animated: true, completion: nil)
    }
    
}
