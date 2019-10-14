//
//  ViewController.swift
//  TodoTimerApp
//
//  Created by 長坂豪士 on 2019/10/12.
//  Copyright © 2019 Tsuyoshi Nagasaka. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var todo: UITextField!

    @IBOutlet weak var estimateTime: UITextField!
    
    @IBOutlet weak var startButton: UIButton!
    
    @IBOutlet weak var resetButton: UIButton!
    
    @IBOutlet weak var doneButton: UIButton!
    
    @IBOutlet weak var stopButton: UIButton!
    
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var recordedLebel: UILabel!
    
    // estimateTimeをクリックした時に表示するPicker
    var timePickerView: UIPickerView = UIPickerView()

    let timePickerOption = ["", "15分", "30分", "45分", "1時間", "1時間15分", "1時間30分", "1時間45分", "2時間"]
    
    let convertedTimePickerOption = [0, 900, 1800, 2700, 3600, 4500, 5400, 6300, 7200]
    
    // timePickerViewの上部のtoolbar
    let toolbar = UIToolbar()
    
    var timer = Timer()
    
    var count = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        todo.delegate = self
        estimateTime.delegate = self
        timePickerView.delegate = self
          
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
        
        // startButtonはクリックできないようにしておく
        startButton.isEnabled = false
        // resetボタン、doneボタン、stopボタン、timerLabel、recordedLabelは非表示にしておく
        resetButton.isHidden = true
        doneButton.isHidden = true
        stopButton.isHidden = true
        timerLabel.isHidden = true
        recordedLebel.isHidden = true
    }
    
    // todoが入力された時の処理
    @IBAction func todoCatchEvent(_ sender: Any) {
        startButton.isEnabled = false
        // todoとestimateTimeの両方が入力されていたらstartButtonをクリックできるようにする
        if todo.text != "" && estimateTime.text != "" {
            startButton.isEnabled = true
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
        // todoとestimateTimeの両方が入力されていたらstartButtonをクリックできるようにする
        if todo.text != "" && estimateTime.text != "" {
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
        stopButton.isHidden = false
        timerLabel.isHidden = false
        doneButton.isEnabled = true
        
        // まだtimerをスタートさせていない場合
        if count == 0 {
            let timePickerOptionIndex = timePickerOption.firstIndex(of: estimateTime.text!)!
            let formattedSetTime = formatTime(remainingTime: convertedTimePickerOption[timePickerOptionIndex])
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
        recordedLebel.isHidden = false
    }
    
    // stopボタンをクリックした時の処理
    @IBAction func clickStopButton(_ sender: Any) {
        timer.invalidate()
        doneButton.isHidden = true
        startButton.isHidden = false
    }
    
    // 1秒ごとに実行する処理
    @objc func updateCurrentTime() {
        count -= 1
        let formattedRemainingTime = formatTime(remainingTime: count)
        timerLabel.text = formattedRemainingTime
    }
    
    // 残りの秒数を表示用のフォーマットに変換する処理
    func formatTime(remainingTime: Int) -> String {
        let h = String(format: "%02d", remainingTime / 3600)
        let m = String(format: "%02d", remainingTime % 3600 / 60)
        let s = String(format: "%02d", remainingTime % 60)
        return("\(h):\(m):\(s)")
    }

}

