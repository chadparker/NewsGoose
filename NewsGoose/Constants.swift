//
//  Constants.swift
//  NewsGoose
//
//  Created by Chad Parker on 3/30/21.
//

import Foundation

struct Constants {
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(secondsFromGMT: 0)!
        formatter.dateStyle = .full
        return formatter
    }()
}
