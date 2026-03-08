import SwiftUI
import SwiftData

struct FavoritesView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    @Query(sort: \QuoteItem.savedDate, order: .reverse) private var favorites: [QuoteItem]
    
    @State private var showingAddSheet = false
    @State private var quoteToEdit: QuoteItem?
    
    
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
        
        
        .sheet(isPresented: $showingAddSheet) {
            AddEditQuoteView(title: "Add Quote") { text, author in
                let new = QuoteItem(text: text, author: author)
                modelContext.insert(new)
            }
        }
        
        
        .sheet(item: $quoteToEdit) { quote in
            AddEditQuoteView(
                title: "Edit Quote",
                initialText: quote.text,
                initialAuthor: quote.author
            ) { text, author in
                
                quote.text = text
                quote.author = author
            }
        }
    }
}

extension FavoritesView {
    
    var portraitLayout: some View {
        
        VStack(spacing: 20) {
            
            HStack {
                Text("Favorites")
                    .font(.title2.bold())
                    .foregroundColor(.white)
                
                Spacer()
            }
            .padding(.horizontal)
            
            
            ScrollView {
                
                LazyVStack(spacing: 15) {
                    
                    ForEach(favorites) { quote in
                        
                        quoteCard(quote)
                        
                    }
                }
                .padding(.horizontal)
            }
            
            
            addButton
                .padding(.horizontal)
                .padding(.bottom, 20)
        }
    }
}

extension FavoritesView {
    
    var landscapeLayout: some View {
        
        VStack {
            
            HStack {
                Text("Favorites")
                    .font(.title2.bold())
                    .foregroundColor(.white)
                
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top, 10)
            
            
            ScrollView {
                
                LazyVStack(spacing: 15) {
                    
                    ForEach(favorites) { quote in
                        
                        quoteCard(quote)
                            .frame(maxWidth: .infinity)
                        
                    }
                }
                .padding(.horizontal)
                .padding(.top, 10)
            }
            
            
            addButton
                .padding(.horizontal)
                .padding(.bottom, 20)
        }
    }
}

extension FavoritesView {
    
    func quoteCard(_ quote: QuoteItem) -> some View {
        
        VStack(alignment: .leading, spacing: 12) {
            
            HStack(alignment: .top) {
                
                Text("\"\(quote.text)\"")
                    .font(.body)
                    .foregroundColor(.white)
                    .italic()
                
                Spacer()
                
                HStack(spacing: 14) {
                    
                    Button {
                        quoteToEdit = quote
                    } label: {
                        Image(systemName: "square.and.pencil")
                            .foregroundColor(.blue)
                    }
                    
                    Button {
                        modelContext.delete(quote)
                    } label: {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                    }
                }
            }
            
            
            Text("\(quote.author) • \(quote.savedDate.formatted(date: .numeric, time: .omitted))")
                .font(.caption)
                .foregroundColor(.blue.opacity(0.8))
        }
        .padding()
        .background(.white.opacity(0.05))
        .cornerRadius(16)
    }
}

extension FavoritesView {
    
    var addButton: some View {
        
        Button {
            showingAddSheet = true
        } label: {
            Text("ADD CUSTOM QUOTE")
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    LinearGradient(
                        colors: [.orange, .pink],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(15)
        }
    }
}
