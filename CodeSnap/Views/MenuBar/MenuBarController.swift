//
//  MenuBarController.swift
//  CodeSnap
//
//  Menu bar dropdown interface
//

import Cocoa
import SwiftUI

class MenuBarController {
    private var statusItem: NSStatusItem
    private var popover: NSPopover?

    init(statusItem: NSStatusItem) {
        self.statusItem = statusItem
        setupPopover()
    }

    private func setupPopover() {
        let popover = NSPopover()
        popover.contentSize = NSSize(
            width: Constants.UI.menuWidth,
            height: Constants.UI.menuMaxHeight
        )
        popover.behavior = .transient
        popover.contentViewController = NSHostingController(
            rootView: MenuBarView()
        )

        self.popover = popover
    }

    func toggleMenu() {
        guard let button = statusItem.button else { return }

        if let popover = popover {
            if popover.isShown {
                popover.performClose(nil)
            } else {
                popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
                // Activate the app to bring window to front
                NSApp.activate(ignoringOtherApps: true)
            }
        }
    }

    func showMenu() {
        guard let button = statusItem.button else { return }
        popover?.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
        NSApp.activate(ignoringOtherApps: true)
    }

    func hideMenu() {
        popover?.performClose(nil)
    }
}
