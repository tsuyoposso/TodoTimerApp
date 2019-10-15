//
//  Contents.swift
//  TodoTimerApp
//
//  Created by 長坂豪士 on 2019/10/14.
//  Copyright © 2019 Tsuyoshi Nagasaka. All rights reserved.
//

import Foundation

//classを使った宣言
class Content {
    let todo: String
    let estimate: Int
    let actual: Int
    let date: Date
    
    init(todo:String, estimate:Int, actual:Int, date:Date) {
        self.todo = todo
        self.estimate = estimate
        self.actual = actual
        self.date = date
    }
}

/*
// structを使った宣言
struct Content {
    let todo: String
    let estimate: Int
    let actual: Int
    let date: Date
}
*/

/*
 最終的に
 todos = [Date: [Content]]()
 dateOrder = [Date]()
 の２つを受け取りたい。
*/
