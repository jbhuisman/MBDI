import Foundation

struct APIService {
    static func fetchKanyeQuote() async throws -> String {
        guard let url = URL(string: "https://api.kanye.rest/") else {
            throw URLError(.badURL)
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoded = try JSONDecoder().decode(KanyeResponse.self, from: data)
        return decoded.quote
    }
    
    static func fetchRandomQuote() async throws -> (quote: String, author: String) {
        // ZenQuotes is betrouwbaarder dan Quotable op dit moment
        guard let url = URL(string: "https://zenquotes.io/api/random") else {
            throw URLError(.badURL)
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        // ZenQuotes geeft een array terug: [{ "q": "text", "a": "author", ... }]
        let decoded = try JSONDecoder().decode([ZenQuoteResponse].self, from: data)
        if let first = decoded.first {
            return (first.q, first.a)
        }
        throw URLError(.cannotParseResponse)
    }
}

struct ZenQuoteResponse: Codable {
    let q: String
    let a: String
}
