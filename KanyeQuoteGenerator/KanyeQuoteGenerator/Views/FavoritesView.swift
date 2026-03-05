import SwiftUI
import SwiftData

struct FavoritesView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \QuoteItem.savedDate, order: .reverse) private var favorites: [QuoteItem]
    
    @State private var showingAddSheet = false
    @State private var quoteToEdit: QuoteItem?
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(colors: [Color(red: 0.1, green: 0.1, blue: 0.2), .black], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                
                VStack {
                    List {
                        ForEach(favorites) { quote in
                            VStack(alignment: .leading, spacing: 5) {
                                Text("\"\(quote.text)\"")
                                    .font(.body)
                                    .foregroundColor(.white)
                                Text("\(quote.author) • \(quote.savedDate.formatted(date: .numeric, time: .omitted))")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            .listRowBackground(Color.white.opacity(0.05))
                            .swipeActions {
                                Button(role: .destructive) {
                                    modelContext.delete(quote)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                                
                                Button {
                                    quoteToEdit = quote
                                } label: {
                                    Label("Edit", systemImage: "pencil")
                                }
                                .tint(.blue)
                            }
                        }
                    }
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
            .navigationTitle("Favorites")
            .toolbarColorScheme(.dark, for: .navigationBar)
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
    
    private func deleteQuotes(offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(favorites[index])
        }
    }
}

// Hulpscherm voor toevoegen/bewerken
struct AddEditQuoteView: View {
    let title: String
    @State var text: String = ""
    @State var author: String = ""
    var onSave: (String, String) -> Void
    
    @Environment(\.dismiss) var dismiss
    
    init(title: String, initialText: String = "", initialAuthor: String = "", onSave: @escaping (String, String) -> Void) {
        self.title = title
        self._text = State(initialValue: initialText)
        self._author = State(initialValue: initialAuthor)
        self.onSave = onSave
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Quote Content") {
                    TextEditor(text: $text)
                        .frame(height: 100)
                }
                Section("Author") {
                    TextField("Name", text: $author)
                }
            }
            .navigationTitle(title)
            .toolbar {
                Button("Save") {
                    onSave(text, author)
                    dismiss()
                }
            }
        }
    }
}
