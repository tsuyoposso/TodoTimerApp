//
//  ConvertTimeStamp.swift
//  TodoTimerApp
//
//  Created by 長坂豪士 on 2019/10/13.
//  Copyright © 2019 Tsuyoshi Nagasaka. All rights reserved.
//

import Foundation

class ConvetTimeStamp {
    
    func convertTimeStamp(serverTimeStamp:CLong) -> String {
        
        let x = serverTimeStamp / 1000
        let date = Date(timeIntervalSince1970: TimeInterval(x))
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .medium
        
        return formatter.string(from: date)
        
    }
}
