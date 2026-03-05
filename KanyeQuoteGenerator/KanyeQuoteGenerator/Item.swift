//
//  Item.swift
//  KanyeQuoteGenerator
//
//  Created by Just Huisman on 05/03/2026.
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
