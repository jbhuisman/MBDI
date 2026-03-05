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
        guard let url = URL(string: "https://api.quotable.io/random") else {
            throw URLError(.badURL)
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoded = try JSONDecoder().decode(QuotableResponse.self, from: data)
        return (decoded.content, decoded.author)
    }
}
