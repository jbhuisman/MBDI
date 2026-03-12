import SwiftUI
import SwiftData

struct GeneratorView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    @Bindable var viewModel: QuoteViewModel
    @State private var isSaved = false
    
    var body: some View {
        
        ZStack {
            LinearGradient(
                colors: [Color(red: 0.1, green: 0.1, blue: 0.2), .black],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            if verticalSizeClass == .compact {
                landscapeLayout
            } else {
                portraitLayout
            }
        }
        // Voer async code uit zodra view verschijnt
        .task {
            if viewModel.currentQuoteAuthor.isEmpty {
                await viewModel.fetchRandomQuote()
            }
        }
    }
}

extension GeneratorView {
    
    var portraitLayout: some View {
        
        VStack(spacing: 25) {
            
            HStack {
                Text("Guess Who?")
                    .font(.title2.bold())
                    .foregroundColor(.white)
                
                Spacer()
                
                Text("Score: \(viewModel.score)")
                    .padding(.horizontal, 15)
                    .padding(.vertical, 8)
                    .background(.ultraThinMaterial)
                    .clipShape(Capsule())
                    .foregroundColor(.blue)
                    .fontWeight(.bold)
            }
            .padding(.horizontal)
            
            quoteCard
                .frame(height: 250)
                .padding(.horizontal)
            
            guessButtons
                .padding(.horizontal)
            
            if let result = viewModel.guessResult {
                Text(result ? "Correct! +10" : "Wrong! It was \(viewModel.currentQuoteAuthor)")
                    .fontWeight(.bold)
                    .foregroundColor(result ? .green : .red)
            }
            
            Spacer()
            
            generateButton
                .padding(.horizontal)
                .padding(.bottom, 20)
        }
    }
}

extension GeneratorView {
    var landscapeLayout: some View {
        
        VStack {
            
            HStack {
                Text("Guess Who?")
                    .font(.title2.bold())
                    .foregroundColor(.white)
                
                Spacer()
                
                Text("Score: \(viewModel.score)")
                    .padding(.horizontal, 15)
                    .padding(.vertical, 8)
                    .background(.ultraThinMaterial)
                    .clipShape(Capsule())
                    .foregroundColor(.blue)
                    .fontWeight(.bold)
            }
            .padding(.horizontal)
            .padding(.top, 10)
            
            
            VStack(spacing: 20) {
                
                HStack(alignment: .top, spacing: 25) {
                    
                    quoteCard
                        .frame(height: 200)
                        .frame(maxWidth: .infinity)
                    
                    VStack(spacing: 15) {
                        
                        guessButtons
                        
                        if let result = viewModel.guessResult {
                            Text(result ? "Correct! +10" : "Wrong! It was \(viewModel.currentQuoteAuthor)")
                                .fontWeight(.bold)
                                .foregroundColor(result ? .green : .red)
                        }
                        
                        Spacer()
                    }
                    .frame(width: 260)
                }
                
                
                generateButton
                    .padding(.horizontal)
            }
            .padding(.horizontal)
            
            Spacer()
        }
    }
    
}
extension GeneratorView {
    
    var quoteCard: some View {
        
        ZStack {
            
            RoundedRectangle(cornerRadius: 24)
                .fill(.white.opacity(0.05))
                .background(.ultraThinMaterial)
            
            VStack {
                
                if viewModel.isLoading {
                    ProgressView()
                        .tint(.white)
                } else {
                    Text("\"\(viewModel.currentQuoteText)\"")
                        .font(.title3)
                        .italic()
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                        .padding(30)
                }
            }
            
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
    }
    
    var guessButtons: some View {
        
        HStack(spacing: 15) {
            guessButton(title: "KANYE", color: .green, isKanye: true)
            guessButton(title: "OTHER", color: .red, isKanye: false)
        }
        .disabled(viewModel.guessResult != nil)
    }
    
    var generateButton: some View {
        
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
                .background(
                    LinearGradient(colors: [.orange, .pink],
                                   startPoint: .leading,
                                   endPoint: .trailing)
                )
                .cornerRadius(15)
        }
    }
}

extension GeneratorView {
    
    @ViewBuilder
    func guessButton(title: String, color: Color, isKanye: Bool) -> some View {
        
        Button(action: { viewModel.guess(isKanye: isKanye) }) {
            
            Text(title)
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    viewModel.guessResult == nil
                    ? color.opacity(0.2)
                    : Color.gray.opacity(0.1)
                )
                .foregroundColor(
                    viewModel.guessResult == nil
                    ? color
                    : .gray
                )
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(
                            viewModel.guessResult == nil
                            ? color.opacity(0.5)
                            : Color.gray.opacity(0.2),
                            lineWidth: 1
                        )
                )
        }
    }
    
    private func toggleSave() {
        
        guard !isSaved else { return }
        
        let newFav = QuoteItem(
            text: viewModel.currentQuoteText,
            author: viewModel.currentQuoteAuthor
        )
        
        modelContext.insert(newFav)
        isSaved = true
    }
}
