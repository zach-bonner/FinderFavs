//
// FinderFavsApp.swift
// FinderFavs
//
// Created by Zachary Bonner on 3/22/25.
//

import SwiftUI

@main
struct FinderFavsApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var favoritesStore = FavoritesStore.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(favoritesStore)
        }
        .windowStyle(HiddenTitleBarWindowStyle())
    }
}
