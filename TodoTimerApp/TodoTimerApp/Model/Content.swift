//
//  Contents.swift
//  TodoTimerApp
//
//  Created by 長坂豪士 on 2019/10/14.
//  Copyright © 2019 Tsuyoshi Nagasaka. All rights reserved.
//

import Foundation

//classを使った宣言
class Content:NSObject, NSCoding {
    
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
    
//    init(from dictionary: [String: Any]) {
//        self.todo = dictionary["todo"] as! String
//        self.estimate = dictionary["estimate"] as! Int
//        self.actual = dictionary["actual"] as! Int
//        self.date = dictionary["date"] as! Date
        
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.todo, forKey: "todo")
        aCoder.encode(self.estimate, forKey: "estimate")
        aCoder.encode(self.actual, forKey: "actual")
        aCoder.encode(self.date, forKey: "date")

    }
    
    required init?(coder aDecoder: NSCoder) {
        todo = aDecoder.decodeObject(forKey: "todo") as! String
        estimate = aDecoder.decodeInteger(forKey: "estimate")
        actual = aDecoder.decodeInteger(forKey: "actual")
        date = aDecoder.decodeObject(forKey: "date") as! Date
    }
    
    /*
    class Class: NSObject, NSCoding {

        let className: String
        let roomName: String
        let cellNumber: Int

        init(className: String, roomName: String, cellNumber: Int) {

            self.className = className
            self.roomName = roomName
            self.cellNumber = cellNumber
        }

        func encode(with aCoder: NSCoder) {
            aCoder.encode(self.className, forKey: "name")
            aCoder.encode(self.roomName, forKey: "room")
            aCoder.encode(self.cellNumber, forKey: "number")
        }

        required init?(coder aDecoder: NSCoder) {
            self.className = aDecoder.decodeObject(forKey: "name") as! String
            self.roomName = aDecoder.decodeObject(forKey: "room") as! String
            self.cellNumber = aDecoder.decodeInteger(forKey: "number")
        }
    }
    */
    
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
