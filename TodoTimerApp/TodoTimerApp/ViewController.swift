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
    
    var TimePickerView: UIPickerView = UIPickerView()

    let TimePickerOption = ["", "15分", "30分", "45分", "1時間", "1時間15分", "1時間30分", "1時間45分", "2時間"]
    
    // TimePickerViewの上部のtoolbarを作成
    let toolbar = UIToolbar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        todo.delegate = self
        estimateTime.delegate = self
        TimePickerView.delegate = self
          
        // toolbarのwidth, heightなどを設定
        toolbar.frame = CGRect(x: 0, y: 100, width: view.frame.size.width, height: 35)

        // toolbarのcancelとdoneのボタンを作成
        let cancelItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        let spacelItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        toolbar.setItems([cancelItem, spacelItem, doneItem], animated: true)

        // estimateTimeをクリックしたらTimePickerViewとtoolbarを表示
        estimateTime.inputView = TimePickerView
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
        return TimePickerOption.count
    }
    
    // PickerViewに表示するデータ
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return TimePickerOption[row]
    }
    
    // PickerViewデータ選択時
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        estimateTime.text = TimePickerOption[row]
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
    }
    
    // resetボタンをクリックした時の処理
    @IBAction func clickResetButton(_ sender: Any) {
        resetButton.isHidden = true
        doneButton.isHidden = true
        stopButton.isHidden = true
        timerLabel.isHidden = true
        recordedLebel.isHidden = true
        startButton.isHidden = false
        
        todo.text = ""
        estimateTime.text = ""
    }
    
    // doneボタンをクリックした時の処理
    @IBAction func clickDoneButton(_ sender: Any) {
        recordedLebel.isHidden = false
    }
    
    // stopボタンをクリックした時の処理
    @IBAction func clickStopButton(_ sender: Any) {
    }

}

