//
//  RecordViewController.swift
//  TodoTimerApp
//
//  Created by 長坂豪士 on 2019/10/12.
//  Copyright © 2019 Tsuyoshi Nagasaka. All rights reserved.
//

import UIKit

class RecordViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {

    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var recordTableView: UITableView!
    
    var convertTime = ConvertTime()

    var todos:[[String: Any]] = [["timeStamp":"1", "todo":"物理", "estimate":1232, "actual":1432]]
    
    // 受け渡される配列
    // 後で消す
    

    // todos.append(timeStamp:"1", todo:"物理", estimate:1232, actual:1432)
    

    override func viewDidLoad() {
        super.viewDidLoad()

        recordTableView.delegate = self
        recordTableView.dataSource = self
        
        // Do any additional setup after loading the view.
    }
    
    
    
    // セクション数
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    // セルの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    // セルの表示
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = recordTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let toDoLabel = cell.viewWithTag(1) as! UILabel
        toDoLabel.text = todos[indexPath.row]["todo"] as? String
        // toDoLabel.text = todos[indexPath.row]["todo"] as? String
        
        let estimateTimeLabel = cell.viewWithTag(2) as! UILabel
        estimateTimeLabel.text = convertTime.convertTime(second: todos[indexPath.row]["estimate"] as! Int)
        // estimateTimeLabel.text = convertTime.convertTime(second: (todos[indexPath.row]["estimate"] as? Int)!)
        
        
        let actualTimeLabel = cell.viewWithTag(3) as! UILabel
        actualTimeLabel.text = convertTime.convertTime(second: todos[indexPath.row]["actual"] as! Int)
        // actualTimeLabel.text = convertTime.convertTime(second: (todos[indexPath.row]["actual"] as? Int)!)
        
        return cell
        
    }
    
    // セルの高さ
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
