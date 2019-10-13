//
//  ConvertTime.swift
//  TodoTimerApp
//
//  Created by 長坂豪士 on 2019/10/13.
//  Copyright © 2019 Tsuyoshi Nagasaka. All rights reserved.
//

import Foundation

class ConvertTime {
    
    func convertTime(second:Int) -> String {
        
        let min: Int = second / 60
        let sec: Int = second % 60
        
        let time: String = "\(min):\(sec)"
        
        return time
    }
    
}


