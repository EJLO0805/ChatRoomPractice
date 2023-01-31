//
//  ChatRoomModel.swift
//  ChatRoomPractice
//
//  Created by 羅以捷 on 2023/1/29.
//

import Foundation
import UIKit


struct ChatRoomModel: Codable{
    var records:[Record]
    struct Record: Codable {
        let fields : Fields
    }
    struct Fields: Codable{
        var name: String
        var content: String
        var sendTimeString: String
    }
}

struct ChatContentModel {
    var name: String = ""
    var content: String = ""
    var sendTime: Date = Date.now
}


