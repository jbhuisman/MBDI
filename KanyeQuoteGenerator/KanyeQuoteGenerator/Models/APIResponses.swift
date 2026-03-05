import Foundation

struct KanyeResponse: Codable {
    let quote: String
}

struct QuotableResponse: Codable {
    let content: String
    let author: String
    let tags: [String]
}
