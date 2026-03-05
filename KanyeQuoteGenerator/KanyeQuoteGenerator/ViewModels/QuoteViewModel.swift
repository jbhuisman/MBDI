import Foundation
import SwiftUI

@Observable
final class QuoteViewModel {
    var currentQuoteText: String = "Press generate to start."
    var currentQuoteAuthor: String = ""
    var score: Int = 0
    var isLoading: Bool = false
    var guessResult: Bool? = nil
    
    func fetchRandomQuote() async {
        isLoading = true
        guessResult = nil
        
        // Randomly decide to fetch a Kanye quote or a random quote
        let isKanye = Bool.random()
        
        do {
            if isKanye {
                let quote = try await APIService.fetchKanyeQuote()
                await MainActor.run {
                    self.currentQuoteText = quote
                    self.currentQuoteAuthor = "Kanye West"
                    self.isLoading = false
                }
            } else {
                let result = try await APIService.fetchRandomQuote()
                await MainActor.run {
                    self.currentQuoteText = result.quote
                    self.currentQuoteAuthor = result.author
                    self.isLoading = false
                }
            }
        } catch {
            await MainActor.run {
                self.currentQuoteText = "Connection error."
                self.isLoading = false
            }
        }
    }
    
    // Evaluate the user's guess and update the score
    func guess(isKanye: Bool) {
        let actuallyKanye = (currentQuoteAuthor == "Kanye West")
        if isKanye == actuallyKanye {
            score += 10
            guessResult = true
        } else {
            score -= 5
            guessResult = false
        }
    }
}
