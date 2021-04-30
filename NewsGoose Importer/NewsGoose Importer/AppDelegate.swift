//
//  AppDelegate.swift
//  NewsGoose Importer
//
//  Created by Chad Parker on 4/29/21.
//

import Cocoa
import SwiftUI
import NGCore

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    var window: NSWindow!

    func applicationDidFinishLaunching(_ aNotification: Notification) {

        let databaseURL = try! FileManager.default
            .url(for: .applicationDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent("db.sqlite")
        try! DatabaseManager.setup(at: databaseURL.path)

        let dataPath = "\(Bundle.main.resourcePath!)/data/"
        let importer = PostImporter(dataPath: dataPath)
        importer.importFromJS()

        let contentView = MainView().environmentObject(importer)

        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered, defer: false)
        window.isReleasedWhenClosed = false
        window.center()
        window.setFrameAutosaveName("Main Window")
        window.contentView = NSHostingView(rootView: contentView)
        window.makeKeyAndOrderFront(nil)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

