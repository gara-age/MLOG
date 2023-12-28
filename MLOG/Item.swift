//
//  Item.swift
//  Malendar
//
//  Created by 최민서 on 11/8/23.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
