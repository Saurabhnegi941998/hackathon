//
//  SodiDesignerView.swift
//  SodiDesigners
//
//  Created by Saurabh Negi on 12/11/25.
//

import SwiftUI

struct SodiDesignerView: View {
    @State private var navigateToNext = false
    @State private var showPopup = false // For slide-up animation

    var body: some View  {
        NavigationStack {
            ZStack {
                // Background
                Color("AppBlue")
                    .ignoresSafeArea()
                
                // Floating Popup Button
                VStack(spacing: 0) {
                    Spacer()
                    Button(action: {
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                        navigateToNext = true
                    }) {
                        HStack(spacing: 10) {
                            Image("Sodimac")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 32, height: 32)
                            
                            Text("SodiDesigners")
                                .font(.headline)
                                .foregroundColor(Color("AppBlue"))
                        }
                        .padding(.horizontal, 24)
                        .padding(.vertical, 16)
                        .background(Color.white)
                        .cornerRadius(20)
                        .shadow(color: .black.opacity(0.2), radius: 6, x: 0, y: 3)
                    }
                    .offset(y: showPopup ? 0 : 200)
                    .opacity(showPopup ? 1 : 0)
                    .animation(.spring(response: 0.6, dampingFraction: 0.7), value: showPopup)
                    .padding(.bottom, 40)
                }
                
            }
            .onAppear {
                withAnimation(.spring(response: 0.7, dampingFraction: 0.8)) {
                    showPopup = true
                }
            }
            .navigationDestination(isPresented: $navigateToNext) {
                CategoryListView() // next screen
            }
        }
    }
}

#Preview {
    SodiDesignerView()
}
