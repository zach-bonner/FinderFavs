//
// FinderScripting.swift
// FinderFavs
//
// Created by Zachary Bonner on 3/22/25.
//

import Cocoa

func getFinderSelectedItems() -> [URL]? {
    let appleScript = """
    tell application "Finder"
        set theSelection to the selection
        set thePaths to {}
        repeat with anItem in theSelection
            set end of thePaths to (POSIX path of (anItem as alias))
        end repeat
    end tell
    return thePaths
    """
    
    var error: NSDictionary?
    guard let script = NSAppleScript(source: appleScript) else {
        print("Error creating AppleScript")
        return nil
    }
    
    let outputDescriptor = script.executeAndReturnError(&error)
    if let error = error {
        print("AppleScript Error: \(error)")
        return nil
    }
    
    if outputDescriptor.descriptorType == typeAEList {
        let count = outputDescriptor.numberOfItems
        var paths: [String] = []
        for i in 1...count {
            if let itemDescriptor = outputDescriptor.atIndex(i),
               let path = itemDescriptor.stringValue {
                paths.append(path)
            }
        }
        let urls = paths.compactMap { URL(fileURLWithPath: $0) }
        return urls
    }
    
    return nil
}
