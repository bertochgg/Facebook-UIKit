//
//  Date+ISO8601Formatting.swift
//  Facebook-iOS
//
//  Created by Humberto Garcia on 29/05/23.
//

import Foundation

extension Date {
    func dateFormatting() -> String {
        let outputDateFormatter = DateFormatter()
        outputDateFormatter.dateFormat = "MMM dd, yyyy"
        
        let formattedDate = outputDateFormatter.string(from: self)
        
        return formattedDate
    }
}
