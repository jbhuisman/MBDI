import SwiftUI

struct ContentView: View {
    @State private var viewModel = QuoteViewModel()
    @State private var showSplash = true
    
    var body: some View {
        if showSplash {
            SplashView()
                .onAppear {
                    // Splash screen verdwijnt na 2.5 seconden
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                        withAnimation {
                            showSplash = false
                        }
                    }
                }
        } else {
            TabView {
                GeneratorView(viewModel: viewModel)
                    .tabItem {
                        Label("Generate", systemImage: "arrow.triangle.2.circlepath")
                    }
                
                FavoritesView()
                    .tabItem {
                        Label("Favorites", systemImage: "heart")
                    }
            }
            .tint(.white) // TabBar icoon kleur
            .preferredColorScheme(.dark)
        }
    }
}
