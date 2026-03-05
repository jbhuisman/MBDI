import SwiftUI

struct SplashView: View {
    var body: some View {
        ZStack {
            // Achtergrond afbeelding met overlay
            AsyncImage(url: URL(string: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQSVuSlHzUyEdcQ_u2y7qiCZZD7EiH5gLsEAE2ABKhn2VnP77ROdPG_Bupn&s=10")) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                    .overlay(Color.black.opacity(0.6))
            } placeholder: {
                Color.black.ignoresSafeArea()
            }
            
            VStack(spacing: 10) {
                Text("KANYE QUOTE")
                    .font(.system(size: 34, weight: .bold, design: .default))
                    .foregroundColor(.white)
                
                Text("GENERATOR")
                    .font(.system(size: 14, weight: .semibold))
                    .tracking(4)
                    .foregroundColor(.gray)
                
                Spacer().frame(height: 50)
                
                ProgressView()
                    .tint(.orange)
                    .scaleEffect(1.5)
            }
        }
    }
}
