//
//  StatusBarContentView.swift
//  FinderFavs
//
//  Created by Zachary Bonner on 3/29/25.
//

import SwiftUI

struct StatusBarContentView: View {
    @EnvironmentObject var favoritesStore: FavoritesStore
    @State private var isDockVisible: Bool = NSApp.activationPolicy() == .regular
    
    var body: some View {
        ZStack {
            
            VStack(spacing: 0) {
                HStack {
                    Text("Favorites")
                        .font(.headline)
                        .foregroundColor(.primary)
                    Spacer()
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                
                Divider()
                
                ScrollView {
                    StatusBarFavoritesView()
                        .environmentObject(favoritesStore)
                        .padding(.horizontal, 12)
                        .foregroundColor(.primary)
                }
                .frame(maxHeight: .infinity)
                
                Divider()
                
                HStack {
                    Button(action: toggleDockIcon) {
                        Text(isDockVisible ? "Hide from Dock" : "Show Dock Icon")
                    }
                    .buttonStyle(.bordered)
                    .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Button("Quit") {
                        NSApp.terminate(nil)
                    }
                    .buttonStyle(.bordered)
                    .foregroundColor(.primary)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
            }
            .frame(width: 300, height: 400)
        }
        .environment(
            \.colorScheme, .dark
        )
    }
    
    private func toggleDockIcon() {
        if isDockVisible {
            NSApp.setActivationPolicy(.accessory)
            isDockVisible = false
        } else {
            NSApp.setActivationPolicy(.regular)
            NSApp.activate(ignoringOtherApps: true)
            isDockVisible = true
        }
    }
}
