//
//  PostImporter.swift
//  HNImporter
//
//  Created by Chad Parker on 4/18/21.
//

import Foundation
import Combine

public class PostImporter: ObservableObject {

    @Published public var fileCountProgress = 0
    @Published public var fileCountTotal: Int = 0
    @Published public var postsImportedCount = 0

    private var fileCounter = PassthroughSubject<Int, Never>()
    private var postCounter = PassthroughSubject<Int, Never>()
    private var fileCounterSubscriber: AnyCancellable?
    private var postCounterSubscriber: AnyCancellable?

    private let importQueue = DispatchQueue(label: "PostImporterQueue", qos: .userInitiated)
    private let fileCountQueue = DispatchQueue(label: "FileCountQueue", qos: .background)
    private let postCountQueue = DispatchQueue(label: "PostCountQueue", qos: .background)

    lazy var calendar: Calendar = {
        var cal = Calendar.current
        cal.timeZone = TimeZone(secondsFromGMT: 0)!
        return cal
    }()

    public init() {
        fileCounterSubscriber = fileCounter
            .throttle(for: 0.1, scheduler: fileCountQueue, latest: true)
            .receive(on: DispatchQueue.main)
            .sink { value in
                self.fileCountProgress = value
            }
        postCounterSubscriber = postCounter
            .throttle(for: 0.1, scheduler: postCountQueue, latest: true)
            .receive(on: DispatchQueue.main)
            .sink { value in
                self.postsImportedCount = value
            }
    }

    public func importFromJS() {
        importQueue.async { [self] in

            // temporary deleteAll for now. more checking & UI later.
            do {
                try dbQueue.write { db in
                    _ = try Post.deleteAll(db)
                }
            } catch {
                fatalError("read error")
            }

            var idsSeen = Set<String>()

            let filePaths = getDataFilePaths()
            DispatchQueue.main.async {
                fileCountTotal = filePaths.count
            }
            for (index, filePath) in filePaths.enumerated() {
                let url = URL(fileURLWithPath: filePath)
                let data = try! Data(contentsOf: url)
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .secondsSince1970
                let posts = try! decoder.decode([Post].self, from: data)

                do {
                    try dbQueue.write { db in

                        for var post in posts {

                            if !idsSeen.contains(post.id) {
                                post.day = calendar.startOfDay(for: post.date)
                                try! post.insert(db)
                                idsSeen.insert(post.id)
                            }
                        }
                    }
                } catch {
                    print("\(error)")
                }
                fileCounter.send(index + 1)
                postCounter.send(idsSeen.count)
            }
        }
    }

    func getDataFilePaths() -> [String] {
        let path = "\(Bundle.main.resourcePath!)/data/"
        do {
            let filenames = try FileManager.default.contentsOfDirectory(atPath: path)
            return filenames.map { path + $0 }
        } catch {
            fatalError()
        }
    }
}