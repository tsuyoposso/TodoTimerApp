//
//  ConvertTime.swift
//  TodoTimerApp
//
//  Created by 長坂豪士 on 2019/10/13.
//  Copyright © 2019 Tsuyoshi Nagasaka. All rights reserved.
//

import Foundation

class FormatTime {
    // 残りの秒数を表示用のフォーマットに変換する処理
    func formatTime(remainingTime: Int) -> String {
        let h = String(format: "%02d", remainingTime / 3600)
        let m = String(format: "%02d", remainingTime % 3600 / 60)
        let s = String(format: "%02d", remainingTime % 60)
        return("\(h):\(m):\(s)")
    }
}



