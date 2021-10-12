//
//  Category.swift
//  Publisher
//
//  Created by Yi-Chin Hsu on 2021/10/12.
//

import Foundation

enum Category: Int, CaseIterable {
    
    case beauty = 0
    case schoolLife
    case other
    
    var title: String {
        
        switch self {
        case .beauty:
            return "Beauty"
        case .schoolLife:
            return "School Life"
        case .other:
            return "Other"
        }
    }
    
}
