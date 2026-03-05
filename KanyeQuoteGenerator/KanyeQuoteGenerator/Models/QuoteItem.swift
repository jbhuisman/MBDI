import Foundation
import SwiftData

@Model
final class QuoteItem {
    var id: UUID
    var text: String
    var author: String
    var savedDate: Date
    
    init(text: String, author: String, savedDate: Date = Date()) {
        self.id = UUID()
        self.text = text
        self.author = author
        self.savedDate = savedDate
    }
}
