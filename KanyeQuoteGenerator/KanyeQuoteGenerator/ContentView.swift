import SwiftUI

struct ContentView: View {
    
    @State private var viewModel = QuoteViewModel()
    @State private var showSplash = true
    
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @State private var selectedTab = 0
    
    var body: some View {
        
        if showSplash {
            
            SplashView()
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                        withAnimation {
                            showSplash = false
                        }
                    }
                }
            
        } else {
            
            if verticalSizeClass == .compact {
                landscapeTabs
            } else {
                portraitTabs
            }
        }
    }
}

extension ContentView {
    
    var portraitTabs: some View {

        TabView(selection: $selectedTab) {

            GeneratorView(viewModel: viewModel)
                .tabItem {
                    Label("Generate", systemImage: "arrow.triangle.2.circlepath")
                }
                .tag(0)

            FavoritesView()
                .tabItem {
                    Label("Favorites", systemImage: "heart")
                }
                .tag(1)
        }
        .tint(.white)
        .preferredColorScheme(.dark)
    }
}

extension ContentView {
    
    var landscapeTabs: some View {
        
        VStack {
            
            HStack {
                
                Button {
                    selectedTab = 0
                } label: {
                    VStack(spacing: 6) {
                        Text("Generate")
                            .font(.headline)
                            .foregroundColor(selectedTab == 0 ? .white : .gray)
                        
                        Rectangle()
                            .fill(Color.white.opacity(0.8))
                            .frame(height: 2)
                            .opacity(selectedTab == 0 ? 1 : 0)
                    }
                }
                .frame(maxWidth: .infinity)
                
                
                Button {
                    selectedTab = 1
                } label: {
                    VStack(spacing: 6) {
                        Text("Favorites")
                            .font(.headline)
                            .foregroundColor(selectedTab == 1 ? .white : .gray)
                        
                        Rectangle()
                            .fill(Color.white.opacity(0.8))
                            .frame(height: 2)
                            .opacity(selectedTab == 1 ? 1 : 0)
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .padding(.horizontal)
            .padding(.top, 10)
            
            
            if selectedTab == 0 {
                GeneratorView(viewModel: viewModel)
            } else {
                FavoritesView()
            }
        }
        .background(.clear)
        .preferredColorScheme(.dark)
    }
}
