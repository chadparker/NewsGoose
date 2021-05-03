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
