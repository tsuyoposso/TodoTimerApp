//
//  ViewController.swift
//  TodoTimerApp
//
//  Created by 長坂豪士 on 2019/10/12.
//  Copyright © 2019 Tsuyoshi Nagasaka. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var estimateTime: UITextField!
    
    var TimepickerView: UIPickerView = UIPickerView()

    let TimepickerOption = ["", "15分", "30分", "45分", "1時間", "1時間15分", "1時間30分", "1時間45分", "2時間"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TimepickerView.delegate = self
            
        // toolBarを作成
        let toolbar = UIToolbar()
        toolbar.frame = CGRect(x: 0, y: 100, width: view.frame.size.width, height: 35)

        // cancelボタンとdoneボタンの作成
        let cancelItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        let spacelItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        toolbar.setItems([cancelItem, spacelItem, doneItem], animated: true)

        // estimateTimeをクリックしたらpickerViewとtoolBarを表示
        estimateTime.inputView = TimepickerView
        estimateTime.inputAccessoryView = toolbar
    }
    
    // PickerViewの列数
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // PickerViewの行数
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return TimepickerOption.count
    }
    
    // PickerViewに表示するデータ
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return TimepickerOption[row]
    }
    
    // PickerViewデータ選択時
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        estimateTime.text = TimepickerOption[row]
    }
    
    // toolBarのcancelボタンをクリックした時の処理
    @objc func cancel() {
        estimateTime.text = ""
        estimateTime.endEditing(true)
    }

    // toolBarのdoneボタンをクリックした時の処理
    @objc func done() {
        estimateTime.endEditing(true)
    }

}

