import SwiftUI
import SwiftData

@main
struct KanyeQuoteGeneratorApp: App {
    var sharedModelContainer: ModelContainer = {
        // We gebruiken hier ons eigen model: QuoteItem
        let schema = Schema([QuoteItem.self])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
