//
// ContentView.swift
// FinderFavs
//
// Created by Zachary Bonner on 3/22/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var favoritesStore: FavoritesStore
    
    var groupedFavorites: [String: [FavoriteItem]] {
        Dictionary(grouping: favoritesStore.favorites, by: { $0.localizedKind })
    }

    var sortedGroupKeys: [String] {
        groupedFavorites.keys.sorted { lhs, rhs in
            if lhs == "Folder" { return true }
            if rhs == "Folder" { return false }
            return lhs < rhs
        }
    }
    
    var body: some View {
        List {
            ForEach(sortedGroupKeys, id: \.self) { key in
                if let items = groupedFavorites[key] {
                    Section(header: Text(key)) {
                        ForEach(items) { item in
                            Button(action: {
                                NSWorkspace.shared.open(item.url)
                            }) {
                                HStack {
                                    if let icon = NSWorkspace.shared.icon(forFile: item.url.path) as NSImage? {
                                        Image(nsImage: icon)
                                            .resizable()
                                            .frame(width: 16, height: 16)
                                    }
                                    Text(item.url.lastPathComponent)
                                }
                            }
                        }
                    }
                }
            }
        }
        .listStyle(SidebarListStyle())
        .frame(minWidth: 300, minHeight: 400)
    }
}
