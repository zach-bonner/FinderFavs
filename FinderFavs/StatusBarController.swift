//
//  StatusBarController.swift
//  FinderFavs
//
//  Created by Zachary Bonner on 3/29/25.
//

import Cocoa
import SwiftUI

class StatusBarController {
    private var statusItem: NSStatusItem
    private lazy var popover: NSPopover = {
        let popover = NSPopover()
        popover.contentSize = NSSize(width: 300, height: 400)
        popover.behavior = .transient
        let contentView = StatusBarFavoritesView().environmentObject(favoritesStore)
        popover.contentViewController = NSHostingController(rootView: contentView)
        return popover
    }()
    
    private let favoritesStore: FavoritesStore

    init(favoritesStore: FavoritesStore) {
        self.favoritesStore = favoritesStore
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let button = statusItem.button {
            button.image = NSImage(systemSymbolName: "heart.circle.fill", accessibilityDescription: "Favorites")
            button.action = #selector(togglePopover(_:))
            button.target = self
        }
    }
    
    @objc func togglePopover(_ sender: AnyObject?) {
        if popover.isShown {
            popover.performClose(sender)
        } else if let button = statusItem.button {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
        }
    }
}
