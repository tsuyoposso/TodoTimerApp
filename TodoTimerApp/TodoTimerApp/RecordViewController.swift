//
//  RecordViewController.swift
//  TodoTimerApp
//
//  Created by 長坂豪士 on 2019/10/12.
//  Copyright © 2019 Tsuyoshi Nagasaka. All rights reserved.
//

import UIKit

//struct Content {
//    let todo: String
//    let estimate: Int
//    let actual: Int
//    let date: Date
//}

class RecordViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var recordTableView: UITableView!
    
    var formatTime = FormatTime()
//    var contents = [Content]()
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
        // 日付を用意して、"yyyy/MM/dd"に変換
//        let f = DateFormatter()
//        f.locale = Locale(identifier: "en_US_POSIX")
//        f.dateFormat = "yyyy/MM/dd"

        // サンプルのを用意
//        let contents = [Content(todo: "物理", estimate: 1234, actual: 1345, date: f.date(from: "2019/10/11")!),
//                        Content(todo: "化学", estimate: 4312, actual: 4444, date: f.date(from: "2019/10/11")!),
//                        Content(todo: "英語", estimate: 1434, actual: 1545, date: f.date(from: "2019/10/12")!),
//                        Content(todo: "数学", estimate: 2222, actual: 2145, date: f.date(from: "2019/10/14")!),
//                        Content(todo: "国語", estimate: 4321, actual: 5333, date: f.date(from: "2019/10/14")!)]
        
//        if UserDefaults.standard.object(forKey: "Contents") != nil {
//            contents = UserDefaults.standard.object(forKey: "contents") as! [Content]
//        }
        var contents: [Content]!
        let contentsData = UserDefaults.standard.object(forKey: "contents") as? Data
        guard let t = contentsData else { return }
        let unArchiveData = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(t)
        contents = unArchiveData as? [Content] ?? [Content]()

        print(contents!)
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
        print("セクションの数を確認")
        print(todos.keys.count)
        return todos.keys.count
    }

    // セルの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let targetDate = dateOrder[section]
        print("セルの数を確認")
        print(todos[targetDate, default: []].count)
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
        toDoLabel.text = content.todo
        
        // estimateの表示
        let estimateTimeLabel = cell.viewWithTag(2) as! UILabel
        estimateTimeLabel.text = formatTime.formatTime(remainingTime: content.estimate)
        
        // actualの表示
        let actualTimeLabel = cell.viewWithTag(3) as! UILabel
        actualTimeLabel.text = formatTime.formatTime(remainingTime: content.actual)
 
        print("セルを返す")
        return cell
        
    }
    
    // セルの高さ
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    // 日付セクションのフォーマット
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let targetDate = dateOrder[section]

        let label = UILabel()
        label.backgroundColor = .lightGray
        label.textColor = .white
        label.text = formatter.string(from: targetDate)

        return label
    }

    @IBAction func backToTimeKeeper(_ sender: Any) {

        dismiss(animated: true, completion: nil)        
    }
    
    
    
    
}
