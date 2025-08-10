//
//  TaskDetailViewController.swift
//  todo_v2
//
//  Created by ueda yamato on 2025/08/10.
//

import UIKit

class TaskDetailViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var dueDateSwitch: UISwitch!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var completedSwitch: UISwitch!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var updatedAtLabel: UILabel!
    
    // MARK: - Properties
    var task: Task!
    var taskIndex: Int!
    var onTaskUpdated: (() -> Void)?
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadTaskData()
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        // ナビゲーションバーの設定
        title = "タスク詳細"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "保存",
            style: .done,
            target: self,
            action: #selector(saveButtonTapped)
        )
        
        // DatePickerの設定
        datePicker.locale = Locale(identifier: "ja_JP")
        datePicker.isHidden = !dueDateSwitch.isOn
        
        // TextViewの設定
        noteTextView.layer.borderColor = UIColor.systemGray4.cgColor
        noteTextView.layer.borderWidth = 1.0
        noteTextView.layer.cornerRadius = 8.0
        noteTextView.font = UIFont.systemFont(ofSize: 16)
    }
    
    private func loadTaskData() {
        guard let task = task else { return }
        
        // フォームにタスクデータを設定
        titleTextField.text = task.title
        noteTextView.text = task.note
        completedSwitch.isOn = task.isCompleted
        
        // 期限の設定
        if let dueDate = task.dueDate {
            dueDateSwitch.isOn = true
            datePicker.date = dueDate
            datePicker.isHidden = false
        } else {
            dueDateSwitch.isOn = false
            datePicker.isHidden = true
        }
        
        // 日付の表示
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        
        createdAtLabel.text = "作成日: " + dateFormatter.string(from: task.createdAt)
        updatedAtLabel.text = "更新日: " + dateFormatter.string(from: task.updatedAt)
    }
    
    // MARK: - IBActions
    @IBAction func dueDateSwitchChanged(_ sender: UISwitch) {
        datePicker.isHidden = !sender.isOn
        
        // スイッチをOFFにしたときは現在時刻に設定
        if sender.isOn {
            datePicker.date = Date()
        }
    }
    
    @objc private func saveButtonTapped() {
        // 入力内容の検証
        guard let title = titleTextField.text, !title.isEmpty else {
            showAlert(title: "エラー", message: "タイトルを入力してください")
            return
        }
        
        // タスクデータを更新
        AppData.shared.tasks[taskIndex].title = title
        AppData.shared.tasks[taskIndex].note = noteTextView.text.isEmpty ? nil : noteTextView.text
        AppData.shared.tasks[taskIndex].dueDate = dueDateSwitch.isOn ? datePicker.date : nil
        AppData.shared.tasks[taskIndex].isCompleted = completedSwitch.isOn
        AppData.shared.tasks[taskIndex].updatedAt = Date()
        
        // データを保存
        AppData.shared.saveAll()
        
        // 一覧画面に更新を通知
        onTaskUpdated?()
        
        // 前の画面に戻る
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func deleteButtonTapped(_ sender: UIButton) {
        let alert = UIAlertController(
            title: "削除確認",
            message: "「\(task.title)」を削除しますか？",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "削除", style: .destructive) { [weak self] _ in
            self?.deleteTask()
        })
        
        alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel))
        
        present(alert, animated: true)
    }
    
    // MARK: - Helper Methods
    private func deleteTask() {
        // タスクを削除
        AppData.shared.tasks.remove(at: taskIndex)
        AppData.shared.saveAll()
        
        // 一覧画面に更新を通知
        onTaskUpdated?()
        
        // 前の画面に戻る
        navigationController?.popViewController(animated: true)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}