//
//  WelcomeView.swift
//  Pdf Editor App
//
//  Created by Shakhzod Botirov on 26/12/24.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 10) {
                Image("Icon")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                    .cornerRadius(50)
                
                Text("Добро пожаловать в PDF Editor")
                    .font(.largeTitle)
                    .multilineTextAlignment(.center)
                
                Text("Создавайте, редактируйте и управляйте вашими PDF-документами.")
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                
                Spacer()
                
                NavigationLink(destination: SavedDocumentsView()) {
                    Text("Начать")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        
                }
                .padding(.vertical)
            }
            .padding()
        }
        
    }
}

#Preview {
    WelcomeView()
}
