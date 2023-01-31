//
//  extension.swift
//  ChatRoomPractice
//
//  Created by 羅以捷 on 2023/1/29.
//

import Foundation
import UIKit


class PaddingLabel : UILabel{
    override func drawText(in rect: CGRect) {
        let padding = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        super.drawText(in: rect.inset(by: padding))
    }
    override var intrinsicContentSize: CGSize {
        let superContent = super.intrinsicContentSize
        let width = superContent.width + 20
        let height = superContent.height + 20
        return CGSize(width: width, height: height)
    }
}

public func dateToString(_ date: Date) -> String{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    dateFormatter.timeZone = TimeZone(secondsFromGMT: 8)
    let dateString = dateFormatter.string(from: date)
    return dateString
}

public func stringToDate(_ dateStr: String) -> Date{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    dateFormatter.timeZone = TimeZone(secondsFromGMT: 8)
    let date = dateFormatter.date(from: dateStr)!
    return date
}
