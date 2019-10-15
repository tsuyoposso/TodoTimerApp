//
//  ViewController.swift
//  TodoTimerApp
//
//  Created by 長坂豪士 on 2019/10/12.
//  Copyright © 2019 Tsuyoshi Nagasaka. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var todoErrorMessage: UILabel!
    
    @IBOutlet weak var todo: UITextField!

    @IBOutlet weak var estimateTime: UITextField!
    
    @IBOutlet weak var startButton: UIButton!
    
    @IBOutlet weak var resetButton: UIButton!
    
    @IBOutlet weak var doneButton: UIButton!
    
    @IBOutlet weak var stopButton: UIButton!
    
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var recordedLebel: UILabel!
    
    // 保存するデータのオブジェクトとそれを格納する配列を用意
    var content = [Content]()
    var contents = [[Content]]()
    
    // estimateTimeをクリックした時に表示するPicker
    var timePickerView: UIPickerView = UIPickerView()

    let timePickerOption = ["", "15分", "30分", "45分", "1時間", "1時間15分", "1時間30分", "1時間45分", "2時間"]
    
    let convertedTimePickerOption = [0, 900, 1800, 2700, 3600, 4500, 5400, 6300, 7200]
    
    // timePickerViewの上部のtoolbar
    let toolbar = UIToolbar()
    
    var timer = Timer()
    
    var count = 0
    
    var formatTime: FormatTime = FormatTime()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        todo.delegate = self
        estimateTime.delegate = self
        timePickerView.delegate = self

        // データを格納する配列を初期化する
        initPrepare()
        
        // toolbarのwidth, heightなどを設定
        toolbar.frame = CGRect(x: 0, y: 100, width: view.frame.size.width, height: 35)

        // toolbarのcancelとdoneのボタンを作成
        let cancelItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        let spacelItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        toolbar.setItems([cancelItem, spacelItem, doneItem], animated: true)

        // estimateTimeをクリックしたらtimePickerViewとtoolbarを表示
        estimateTime.inputView = timePickerView
        estimateTime.inputAccessoryView = toolbar
        
        // todoErrorMessageは非表示にしておく
        todoErrorMessage.isHidden = true
        
        // startButtonはクリックできないようにしておく
        startButton.isEnabled = false
        // resetボタン、doneボタン、stopボタン、timerLabel、recordedLabelは非表示にしておく
        resetButton.isHidden = true
        doneButton.isHidden = true
        stopButton.isHidden = true
        timerLabel.isHidden = true
        recordedLebel.isHidden = true
    }
    
    func initPrepare() {
        let f = DateFormatter()
        f.locale = Locale(identifier: "en_US_POSIX")
        f.dateFormat = "yyyy/MM/dd"
        
        let sumple1 = [Content(todo: "物理", estimate: 1234, actual: 1345, date: f.date(from: "2019/10/11")!)]
        let sumple2 = [Content(todo: "化学", estimate: 4312, actual: 4444, date: f.date(from: "2019/10/11")!)]
        let sumple3 = [Content(todo: "数学", estimate: 2222, actual: 2145, date: f.date(from: "2019/10/14")!)]
        contents.append(sumple1)
        contents.append(sumple2)
        contents.append(sumple3)
    }
    
    // todoが入力された時の処理
    @IBAction func todoCatchEvent(_ sender: Any) {
        startButton.isEnabled = false
        
        // 20文字を超えた場合はtodoErrorMessageを表示
        if (todo.text! as NSString).length > 20 {
            todoErrorMessage.isHidden = false
        } else  {
            todoErrorMessage.isHidden = true
            // todoとestimateTimeの両方が入力されていたらstartButtonをクリックできるようにする
            if todo.text != "" && estimateTime.text != "" {
                startButton.isEnabled = true
            }

        }
    }
    
    // PickerViewの列数
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // PickerViewの行数
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return timePickerOption.count
    }
    
    // PickerViewに表示するデータ
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return timePickerOption[row]
    }
    
    // PickerViewデータ選択時
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        estimateTime.text = timePickerOption[row]
        startButton.isEnabled = false
        // todoとestimateTimeの両方が入力されている&todoの文字数が20文字以内の場合、startButtonをクリックできるようにする
        if todo.text != "" && estimateTime.text != "" && (todo.text! as NSString).length <= 20 {
            startButton.isEnabled = true
        }
    }
    
    // toolbarのcancelボタンをクリックした時の処理
    @objc func cancel() {
        estimateTime.text = ""
        startButton.isEnabled = false
        estimateTime.endEditing(true)
    }

    // toolbarのdoneボタンをクリックした時の処理
    @objc func done() {
        estimateTime.endEditing(true)
    }
    
    // returnキーをクリックした時にキーボードを閉じる
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // タッチした時にキーボードを閉じる
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // startボタンをクリックした時の処理
    @IBAction func clickStartButton(_ sender: Any) {
        startButton.isHidden = true
        resetButton.isHidden = false
        doneButton.isHidden = false
        stopButton.isEnabled = true
        stopButton.isHidden = false
        timerLabel.isHidden = false
        doneButton.isEnabled = true
        
        // まだtimerをスタートさせていない場合
        if count == 0 {
            let timePickerOptionIndex = timePickerOption.firstIndex(of: estimateTime.text!)!
            let formattedSetTime = formatTime.formatTime(remainingTime: convertedTimePickerOption[timePickerOptionIndex])
            timerLabel.text = formattedSetTime
            count = convertedTimePickerOption[timePickerOptionIndex]
        }
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCurrentTime), userInfo: nil, repeats: true)
    }
    
    // resetボタンをクリックした時の処理
    @IBAction func clickResetButton(_ sender: Any) {
        timer.invalidate()
        
        todo.text = ""
        estimateTime.text = ""
        count = 0
        // timePickerViewを一番上を選択した状態に戻す
        timePickerView.selectRow(0, inComponent: 0, animated: true)
        
        resetButton.isHidden = true
        doneButton.isHidden = true
        stopButton.isHidden = true
        timerLabel.isHidden = true
        recordedLebel.isHidden = true
        startButton.isEnabled = false
        startButton.isHidden = false
    }
    
    // doneボタンをクリックした時の処理
    @IBAction func clickDoneButton(_ sender: Any) {
        timer.invalidate()
        doneButton.isEnabled = false
        stopButton.isEnabled = false
        resetButton.isEnabled = false
        recordedLebel.isHidden = false
        
        // データをcontentに格納して、contentsにappend
        // さらにUserDefaultsに保存する
        let todoString:String = todo.text!
        var estimateInt:Int = Int()
        var auctualInt:Int = Int()
        let now:Date = Date()
        
        let index = timePickerOption.firstIndex(of: estimateTime.text!)
        estimateInt = convertedTimePickerOption[index!]
        auctualInt = estimateInt - count
        
        // done!押下時の時間を"yyyy/mm/dd"に変換する
        let f = DateFormatter()
        f.timeStyle = .none
        f.dateStyle = .medium
        f.locale = Locale(identifier: "ja_JP")
        let s = f.string(from: now)
        
        // contentに書き込み、contentsにappend
        content = [Content(todo: todoString, estimate: estimateInt, actual: auctualInt, date: f.date(from: s)!)]
        contents.append(content)
        
        // UserDefaultsに保存
        UserDefaults.standard.set(contents, forKey: "contents")
        
        // segueでRecordVCに遷移する、done!押下後1秒後に遷移する
        
        
        
        
    }
    
    // stopボタンをクリックした時の処理
    @IBAction func clickStopButton(_ sender: Any) {
        timer.invalidate()
        stopButton.isEnabled = false
        doneButton.isHidden = true
        startButton.isHidden = false
    }
    
    // 1秒ごとに実行する処理
    @objc func updateCurrentTime() {
        count -= 1
        let formattedRemainingTime = formatTime.formatTime(remainingTime: count)
        timerLabel.text = formattedRemainingTime
    }

}

