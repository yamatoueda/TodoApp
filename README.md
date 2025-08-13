# TodoApp

## 概要
**Todoアプリ（タスク管理アプリ）**として、タスクの作成から管理、表示までを行えるシンプルかつ機能的なアプリです。

---

## 主要機能

### 1. タスク管理
- タスクの作成、編集、削除  
- タスクのタイトル、メモ、期限設定  
- 完了 / 未完了の切り替え  

### 2. タスク一覧表示
- 全タスクをリスト形式で表示  
- 完了済みタスクは取り消し線付きで表示  
- タスクが0件の場合は「タスクはありません」を表示  

### 3. ソート機能
- 作成日順（古い順 / 新しい順）  
- 期限順（近い順 / 遠い順）  
- ナビゲーションバーのソートボタンから選択可能  

### 4. スワイプ操作
- **右スワイプ**：完了 / 未完了の切り替え  
- **左スワイプ**：削除（確認ダイアログ付き）  

### 5. タスク詳細画面
- タスクのタイトル、メモ、期限、完了状態を編集可能  
- 作成日・更新日の表示  
- 削除機能を搭載  

### 6. データ永続化
- `StorageManager` によるローカルデータ保存  
- アプリ終了後もデータを保持  

---

## 画面構成

- **タスク一覧画面**（`TaskListViewController`）：メイン画面  
- **タスク追加画面**（`AddTaskViewController`）：半モーダル表示  
- **タスク詳細画面**（`TaskDetailViewController`）：ナビゲーション遷移


## 画面キャプチャ

### タスク追加画面
<p align="center">
  <img src="https://github.com/user-attachments/assets/e59b06cb-0b4a-4a3f-bd65-720bb6481465" alt="タスク追加画面" width="200">
</p>

### タスク詳細画面
<p align="center">
  <img src="https://github.com/user-attachments/assets/77af019b-e0f0-4159-a404-36a0dc008a01" alt="タスク詳細画面" width="200">
</p>

### タスク一覧画面
<p align="center">
  <img src="https://github.com/user-attachments/assets/015747e4-751a-429e-ba7a-35fb9974f1e0" alt="一覧画面_未完了" width="200">
  <img src="https://github.com/user-attachments/assets/306b4fb2-12eb-4d6f-a072-f3cfededb2c1" alt="一覧画面_削除" width="200">
  <img src="https://github.com/user-attachments/assets/2a481e4b-a675-4589-bcc1-be9085dcc5c4" alt="一覧画面_作成日_新しい順" width="200">
  <img src="https://github.com/user-attachments/assets/3e250e20-a4c8-4cc0-808d-500da9949722" alt="一覧画面_期限_近い順" width="200">
  <img src="https://github.com/user-attachments/assets/5bb9754a-e28b-4abd-9e61-d22ed1b81000" alt="一覧画面_完了" width="200">
  <img src="https://github.com/user-attachments/assets/adcbd2ce-cfa9-4aeb-8872-953d1b90a877" alt="一覧画面_ソート方法を選択" width="200">
</p>
