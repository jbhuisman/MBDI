import SwiftUI
import SwiftData

struct FavoritesView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \QuoteItem.savedDate, order: .reverse) private var favorites: [QuoteItem]
    
    @State private var showingAddSheet = false
    @State private var quoteToEdit: QuoteItem?
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [Color(red: 0.1, green: 0.1, blue: 0.2), .black], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack(alignment: .leading) {
                Text("Favorites")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                    .padding([.horizontal, .top])
                
                List {
                    ForEach(favorites) { quote in
                        VStack(alignment: .leading, spacing: 12) {
                            
                            HStack(alignment: .top) {
                                Text("\"\(quote.text)\"")
                                    .font(.body)
                                    .foregroundColor(.white)
                                    .italic()

                                Spacer()

                                HStack(spacing: 15) {
                                    Button(action: { quoteToEdit = quote }) {
                                        Image(systemName: "square.and.pencil")
                                    }
                                    
                                    Button(action: { modelContext.delete(quote) }) {
                                        Image(systemName: "trash")
                                    }
                                }
                            }

                            Text("\(quote.author) • \(quote.savedDate.formatted(date: .numeric, time: .omitted))")
                                .font(.caption)
                                .foregroundColor(.blue.opacity(0.8))
                        }
                        .padding()
                                .background(Color.white.opacity(0.05))
                                .cornerRadius(16)
                                .listRowBackground(Color.clear)
                            }
                        }
                        .listStyle(.plain)
                        .scrollContentBackground(.hidden)
                
                Button(action: { showingAddSheet = true }) {
                    Text("ADD CUSTOM QUOTE")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(LinearGradient(colors: [.orange, .pink], startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(15)
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
        }
        .sheet(isPresented: $showingAddSheet) {
            AddEditQuoteView(title: "Add Quote") { text, author in
                let new = QuoteItem(text: text, author: author)
                modelContext.insert(new)
            }
        }
        .sheet(item: $quoteToEdit) { quote in
            AddEditQuoteView(title: "Edit Quote", initialText: quote.text, initialAuthor: quote.author) { text, author in
                quote.text = text
                quote.author = author
            }
        }
    }
}
