//
//  AppDelegate.swift
//  FinderFavs
//
//  Created by Zachary Bonner on 3/22/25.
//

import Cocoa
import Carbon

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusBarController: StatusBarController?
    var hotkeyManager: GlobalHotkeyManager?

    func applicationDidFinishLaunching(_ notification: Notification) {
        let favoritesStore = FavoritesStore.shared

        statusBarController = StatusBarController(favoritesStore: favoritesStore)
        
        hotkeyManager = GlobalHotkeyManager.shared
        hotkeyManager?.favoriteCallback = {
            if let urls = getFinderSelectedItems() {
                for url in urls {
                    favoritesStore.addFavorite(url: url)
                }
            }
        }
        hotkeyManager?.registerHotkey()
    }
    
    func applicationWillTerminate(_ notification: Notification) {
    }
}
