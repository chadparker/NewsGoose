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

        Database.directory = try! FileManager.default
            .url(for: .applicationDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent("database", isDirectory: true)

        let dataPath = "\(Bundle.main.resourcePath!)/data/"
        let mainViewModel = MainViewModel()
        let importer = PostImporter(dataPath: dataPath, progressReader: mainViewModel)
        importer.importFromJS()

        let contentView = MainView().environmentObject(mainViewModel)

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

