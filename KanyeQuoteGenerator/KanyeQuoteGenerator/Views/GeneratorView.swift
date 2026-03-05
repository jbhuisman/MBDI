import SwiftUI
import SwiftData

struct GeneratorView: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var viewModel: QuoteViewModel
    @State private var isSaved: Bool = false
    
    // Kleuren voor de knoppen
    let orangePink = LinearGradient(colors: [.orange, .pink], startPoint: .leading, endPoint: .trailing)
    
    var body: some View {
        ZStack {
            // Donkere Gradient Achtergrond
            LinearGradient(colors: [Color(red: 0.1, green: 0.1, blue: 0.2), .black], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack(spacing: 25) {
                // Header met Score
                HStack {
                    Text("Guess Who?")
                        .font(.title2.bold())
                        .foregroundColor(.white)
                    Spacer()
                    HStack(spacing: 5) {
                        Text("Score:")
                            .foregroundColor(.gray)
                        Text("\(viewModel.score)")
                            .foregroundColor(.blue)
                    }
                    .padding(.horizontal, 15)
                    .padding(.vertical, 8)
                    .background(.ultraThinMaterial)
                    .clipShape(Capsule())
                }
                .padding(.horizontal)
                
                // Quote Box (Glassmorphism)
                ZStack {
                    RoundedRectangle(cornerRadius: 24)
                        .fill(.white.opacity(0.05))
                        .background(.ultraThinMaterial)
                        .overlay(RoundedRectangle(cornerRadius: 24).stroke(.white.opacity(0.1), lineWidth: 1))
                    
                    VStack {
                        if viewModel.isLoading {
                            ProgressView().tint(.white)
                        } else {
                            Text("\"\(viewModel.currentQuoteText)\"")
                                .font(.title3)
                                .italic()
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white)
                                .padding(30)
                        }
                    }
                    
                    // Hartje (Like)
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Button(action: toggleSave) {
                                Image(systemName: isSaved ? "heart.fill" : "heart")
                                    .font(.title2)
                                    .foregroundColor(isSaved ? .red : .gray)
                                    .padding()
                            }
                        }
                    }
                }
                .frame(height: 250)
                .padding(.horizontal)
                
                // Guess Buttons
                HStack(spacing: 15) {
                    Button(action: { viewModel.guess(isKanye: true) }) {
                        Text("KANYE")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green.opacity(0.2))
                            .foregroundColor(.green)
                            .cornerRadius(12)
                            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.green.opacity(0.5), lineWidth: 1))
                    }
                    
                    Button(action: { viewModel.guess(isKanye: false) }) {
                        Text("OTHER")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red.opacity(0.2))
                            .foregroundColor(.red)
                            .cornerRadius(12)
                            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.red.opacity(0.5), lineWidth: 1))
                    }
                }
                .padding(.horizontal)
                
                // Feedback tekst
                if let result = viewModel.guessResult {
                    Text(result ? "Correct! +10" : "Incorrect! -5")
                        .fontWeight(.bold)
                        .foregroundColor(result ? .green : .red)
                }
                
                Spacer()
                
                // Generate Knop
                Button(action: {
                    Task {
                        await viewModel.fetchRandomQuote()
                        isSaved = false
                    }
                }) {
                    Text("GENERATE QUOTE")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(orangePink)
                        .cornerRadius(15)
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
            .padding(.top, 20)
        }
        .task {
            if viewModel.currentQuoteAuthor.isEmpty {
                await viewModel.fetchRandomQuote()
            }
        }
    }
    
    private func toggleSave() {
        if isSaved {
            // Logica om te verwijderen (optioneel voor dit scherm)
        } else {
            let newFav = QuoteItem(text: viewModel.currentQuoteText, author: viewModel.currentQuoteAuthor)
            modelContext.insert(newFav)
            isSaved = true
        }
    }
}
