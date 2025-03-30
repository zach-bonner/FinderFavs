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
    
    func applicationDockMenu(_ sender: NSApplication) -> NSMenu? {
        let menu = NSMenu()
        let currentPolicy = NSApp.activationPolicy()
        let menuItemTitle = (currentPolicy == .regular) ? "Hide from Dock" : "Show in Dock"
        menu.addItem(withTitle: menuItemTitle, action: #selector(toggleDockIcon), keyEquivalent: "")
        return menu
    }
    
    // Toggle the activation policy.
    @objc func toggleDockIcon() {
        if NSApp.activationPolicy() == .regular {
            // Switch to accessory mode to hide the dock icon.
            NSApp.setActivationPolicy(.accessory)
        } else {
            // Switch back to regular mode to show the dock icon.
            NSApp.setActivationPolicy(.regular)
            // Optionally, activate the app so the dock icon appears promptly.
            NSApp.activate(ignoringOtherApps: true)
        }
    }
    
    func applicationWillTerminate(_ notification: Notification) {
    }
}
