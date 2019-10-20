//
//  FormatTime.swift
//  TodoTimerApp
//
//  Created by 西宇絢加 on 2019/10/14.
//  Copyright © 2019 Tsuyoshi Nagasaka. All rights reserved.
//

import Foundation

class FormatTime {

    // 秒数をhh:mm:ssのフォーマットに変換する処理
    func formatTime(remainingTime: Int) -> String {
        let absoluteRemainingTime = abs(remainingTime)
        let h = String(format: "%02d", absoluteRemainingTime / 3600)
        let m = String(format: "%02d", absoluteRemainingTime % 3600 / 60)
        let s = String(format: "%02d", absoluteRemainingTime % 60)
        return("\(h):\(m):\(s)")
    }
}
