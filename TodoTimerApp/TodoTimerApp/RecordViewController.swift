//
//  RecordViewController.swift
//  TodoTimerApp
//
//  Created by 長坂豪士 on 2019/10/12.
//  Copyright © 2019 Tsuyoshi Nagasaka. All rights reserved.
//

import UIKit


class RecordViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var recordTableView: UITableView!
    
    var formatTime = FormatTime()
    var contents = [Content]()
    var todos = [Date: [Content]]()
    var dateOrder = [Date]()
    
    // var todos:[[String: Any]] = [["timeStamp":"1", "todo":"物理", "estimate":1232, "actual":1432]]

    override func viewDidLoad() {
        super.viewDidLoad()

        recordTableView.delegate = self
        recordTableView.dataSource = self
        
        prepare()
        
    }
    
    private func prepare() {
        // UserDefaultsの読み込み
        let contentsData = UserDefaults.standard.object(forKey: "contents") as? Data
        guard let t = contentsData else { return }
        let unArchiveData = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(t)
        contents = unArchiveData as? [Content] ?? [Content]()

        // contents内のdate(日付)でグルーピングして、[Date: [Content]]型にキャストする
        todos = Dictionary(grouping: contents) { content -> Date in
            return content.date
        }
        .reduce(into: [Date: [Content]]()) {dic, tuple in
            dic[tuple.key] = tuple.value.sorted { $0.date < $1.date }
        }
        
        // 日付順を保持するための配列
        dateOrder = Array(todos.keys).sorted { $0 > $1 }
        
    }
    
    //セクションに表示するに日付を用意
    private var formatter: DateFormatter  {
        let f = DateFormatter()
        f.dateStyle = .medium
        f.timeStyle = .none
        f.locale = Locale(identifier: "ja_JP")
        return f
    }
    
    // セクション数
    func numberOfSections(in tableView: UITableView) -> Int {
        return todos.keys.count
    }

    // セルの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let targetDate = dateOrder[section]
        return todos[targetDate, default: []].count
    }
    
    // セルの表示
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = recordTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let targetDate = dateOrder[indexPath.section]
        guard let content = todos[targetDate]?[indexPath.row] else {
            return cell
        }
        
        // todoの表示
        let toDoLabel = cell.viewWithTag(1) as! UILabel
        toDoLabel.font = UIFont(name: "Menlo", size: 17.0)
        toDoLabel.text = content.todo
        
        // estimateの表示
        let estimateTimeLabel = cell.viewWithTag(2) as! UILabel
        estimateTimeLabel.font = UIFont(name: "Menlo", size: 15.0)
        estimateTimeLabel.text = formatTime.formatTime(remainingTime: content.estimate)
        
        // actualの表示
        let actualTimeLabel = cell.viewWithTag(3) as! UILabel
        actualTimeLabel.font = UIFont(name: "Menlo", size: 15.0)
        // 配色の設定
        if content.estimate >= content.actual {
            actualTimeLabel.textColor = UIColor(red: 78/255, green: 161/255, blue: 213/255, alpha: 1.0)
        } else {
            actualTimeLabel.textColor = UIColor(red: 233/255, green: 64/255, blue: 65/255, alpha: 1.0)
        }
        actualTimeLabel.text = formatTime.formatTime(remainingTime: content.actual)
 
        return cell
        
    }
    
    // セルの高さ
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    // 日付セクションのフォーマット
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let targetDate = dateOrder[section]

        let label = UILabel()
        label.font = UIFont(name: "Menlo", size: 15.0)
        label.backgroundColor = .lightGray
        label.textColor = .white
        label.text = formatter.string(from: targetDate)

        return label
    }

    // 前画面に戻る
    @IBAction func backToTimeKeeper(_ sender: Any) {
        dismiss(animated: true, completion: nil)        
    }
    
    //セルの編集許可
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    // スワイプしたセルを削除する
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            // スワイプした日付を取得
            let removeTergetDate = dateOrder[indexPath.section]
            // contentsから削除するために、削除した内容と一致するcontentsのindexを取得する
            let removeIndex = contents.firstIndex(of: (todos[removeTergetDate]?[indexPath.row])!)
            // contentsから削除
            contents.remove(at: removeIndex!)
            // 削除する表示のためにtodosからも削除する
            todos[removeTergetDate]!.remove(at: indexPath.row)
            // 削除のアニメーション
            tableView.deleteRows(at: [indexPath as IndexPath], with: UITableView.RowAnimation.automatic)
            
            // セクション内のtodoが全て消えたら日付を消したい
//            if todos[removeTergetDate]?.count == 0 {
//                todos.removeValue(forKey: removeTergetDate)
//                dateOrder.remove(at: indexPath.section)
//            }
            // UserDefaultsを更新
            let encodedContents = try? NSKeyedArchiver.archivedData(withRootObject: contents, requiringSecureCoding: false)
            UserDefaults.standard.set(encodedContents, forKey: "contents")
            UserDefaults.standard.synchronize()
        }
        
    }
    
}
