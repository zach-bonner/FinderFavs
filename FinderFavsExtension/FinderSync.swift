//
//  FinderSync.swift
//  FinderFavsExtension
//
//  Created by Zachary Bonner on 3/22/25.
//

import Cocoa
import FinderSync
import AppKit

class FinderSync: FIFinderSync {
    
    let favoritesStore = FavoritesStore.shared
    
    override init() {
        super.init()
        FIFinderSyncController.default().directoryURLs = [URL(fileURLWithPath: "/")]
    }
    
    override func menu(for menuKind: FIMenuKind) -> NSMenu? {
        let menu = NSMenu(title: "")
        let favoriteMenuItem = NSMenuItem(title: "Favorite", action: #selector(addToFavorites(_:)), keyEquivalent: "")
        favoriteMenuItem.target = self
        menu.addItem(favoriteMenuItem)
        return menu
    }
    
    @objc func addToFavorites(_ sender: AnyObject?) {
        guard let targetURLs = FIFinderSyncController.default().selectedItemURLs() else { return }
        for url in targetURLs {
            favoritesStore.addFavorite(url: url)
        }
    }
}
