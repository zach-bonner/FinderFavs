//
// GlobalHotkeyManager.swift
// FinderFavs
//
// Created by Zachary Bonner on 3/22/25.
//

import Carbon
import Cocoa

class GlobalHotkeyManager {
    var favoriteCallback: (() -> Void)?

    private var hotKeyRef: EventHotKeyRef?

    func registerHotkey() {
        let eventHotKeyID = EventHotKeyID(signature: OSType("FAVS".fourCharCodeValue),
                                          id: 1)

        // Command + Shift + F
        let modifiers: UInt32 = UInt32(cmdKey | shiftKey)
        let keyCode: UInt32 = 3 // F key

        let status = RegisterEventHotKey(keyCode, modifiers, eventHotKeyID, GetApplicationEventTarget(), 0, &hotKeyRef)
        if status != noErr {
            print("Error registering hotkey: \(status)")
        } else {
            print("Hotkey registered successfully")
        }

        // Install handler
        let eventSpec = EventTypeSpec(eventClass: OSType(kEventClassKeyboard),
                                      eventKind: UInt32(kEventHotKeyPressed))

        InstallEventHandler(GetEventDispatcherTarget(), { (nextHandler, event, userData) -> OSStatus in
            var hkID = EventHotKeyID()
            GetEventParameter(event,
                              EventParamName(kEventParamDirectObject),
                              EventParamType(typeEventHotKeyID),
                              nil,
                              MemoryLayout<EventHotKeyID>.size,
                              nil,
                              &hkID)

            if hkID.signature == OSType("FAVS".fourCharCodeValue) {
                DispatchQueue.main.async {
                    GlobalHotkeyManager.shared?.favoriteCallback?()
                }
            }
            return noErr
        }, 1, [eventSpec], nil, nil)
    }

    static var shared: GlobalHotkeyManager? = GlobalHotkeyManager()
}

extension String {
    var fourCharCodeValue: FourCharCode {
        var result: FourCharCode = 0
        for char in utf16 {
            result = (result << 8) + FourCharCode(char)
        }
        return result
    }
}
