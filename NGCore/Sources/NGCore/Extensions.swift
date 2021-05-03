//
//  Extensions.swift
//  
//
//  Created by Chad Parker on 5/3/21.
//

import Foundation

public extension String {

    var digitsOnlyIntValue: Int {
        let digitsString = self.replacingOccurrences(
            of: "\\D",
            with: "",
            options: .regularExpression,
            range: self.startIndex..<self.endIndex
        )
        return Int(digitsString) ?? 0
    }
}

extension DateFormatter {

    static var jsIntFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        return formatter
    }()
}

extension Date {

    var jsInt: Int {
        return Int(DateFormatter.jsIntFormatter.string(from: self))!
    }
}
