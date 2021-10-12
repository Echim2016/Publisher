//
//  Date+Extension.swift
//  Publisher
//
//  Created by Yi-Chin Hsu on 2021/10/12.
//

import Foundation

extension Date {
    
    func getFormattedDate(format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: self)
    }
}
