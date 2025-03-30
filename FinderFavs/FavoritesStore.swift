//
// FavoritesStore.swift
// FinderFavs
//
// Created by Zachary Bonner on 3/22/25.
//

import SwiftUI
import UniformTypeIdentifiers

struct FavoriteItem: Identifiable, Codable, Equatable {
    let id: UUID
    let url: URL
    let dateAdded: Date
    
    init(url: URL) {
        self.id = UUID()
        self.url = url
        self.dateAdded = Date()
    }
}

class FavoritesStore: ObservableObject {
    static let shared = FavoritesStore()
    private let userDefaultsKey = "favorites"
    private let appGroupID = "group.M9R94CSRBB"

    @Published var favorites: [FavoriteItem] = []
    
    private init() {
        loadFavorites()
    }
    
    private func getUserDefaults() -> UserDefaults? {
        return UserDefaults(suiteName: appGroupID)
    }
    
    func loadFavorites() {
        guard let defaults = getUserDefaults() else { return }
        if let data = defaults.data(forKey: userDefaultsKey),
           let items = try? JSONDecoder().decode([FavoriteItem].self, from: data) {
            self.favorites = items
        }
    }
    
    func saveFavorites() {
        guard let defaults = getUserDefaults() else { return }
        if let data = try? JSONEncoder().encode(favorites) {
            defaults.set(data, forKey: userDefaultsKey)
        }
    }
    
    func addFavorite(url: URL) {
        if !favorites.contains(where: { $0.url == url }) {
            let newItem = FavoriteItem(url: url)
            favorites.append(newItem)
            saveFavorites()
        }
    }
    
    func removeFavorite(item: FavoriteItem) {
        favorites.removeAll(where: { $0.id == item.id })
        saveFavorites()
    }
    
    func removeFavorites(at offsets: IndexSet) {
        offsets.forEach { index in
            let item = favorites[index]
            removeFavorite(item: item)
        }
    }
}


import UniformTypeIdentifiers

extension FavoriteItem {
    var localizedKind: String {
        if FileManager.default.fileExists(atPath: url.path, isDirectory: nil),
           let utiIdentifier = try? url.resourceValues(forKeys: [.typeIdentifierKey]).typeIdentifier,
           let type = UTType(utiIdentifier) {
            return type.localizedDescription!
        }
        return "Unknown"
    }
}
