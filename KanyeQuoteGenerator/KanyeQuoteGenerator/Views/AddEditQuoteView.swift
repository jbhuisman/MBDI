import SwiftUI

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
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        onSave(text, author)
                        dismiss()
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
}
