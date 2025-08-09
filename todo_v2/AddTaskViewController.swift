//
//  AddTaskViewController.swift
//  todo_v2
//
//  Created by ueda yamato on 2025/08/07.
//

import UIKit

class AddTaskViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var dueDateSwitch: UISwitch!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var saveButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.locale = Locale(identifier: "ja_JP") // datePickerを日本語に設定
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // モダールから戻ったあとの挙動書く
        // tableView.reloadData()
    }
    
    @IBAction func dueDateSwitchChanged(_ sender: UISwitch) {
        datePicker.isHidden = !sender.isOn
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

        let dueDate = dueDateSwitch.isOn ? datePicker.date : nil

        let task = Task(title: title, dueDate: dueDate)

        AppData.shared.tasks.append(task)
        AppData.shared.saveAll()

        dismiss(animated: true) {
            NotificationCenter.default.post(name: NSNotification.Name("TaskAdded"), object: nil)
        }
    }
    
}
