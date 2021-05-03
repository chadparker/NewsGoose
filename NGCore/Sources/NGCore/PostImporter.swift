//
//  PostImporter.swift
//  HNImporter
//
//  Created by Chad Parker on 4/18/21.
//

import Foundation
import Combine

public protocol ImporterProgress: AnyObject {
    var fileCountTotal: Int { get set }
    var fileCounter: PassthroughSubject<Int, Never> { get set }
    var postCounter: PassthroughSubject<Int, Never> { get set }
}

public final class PostImporter: ObservableObject {

    private let importQueue = DispatchQueue(label: "PostImporterQueue", qos: .userInitiated)

    let dataPath: String
    weak var progressReader: ImporterProgress?

    public init(dataPath: String, progressReader: ImporterProgress) {
        self.dataPath = dataPath
        self.progressReader = progressReader
    }

    public func importFromJS() {
        importQueue.async { [self] in

            // temporary deleteAll for now. more checking & UI later.
            try! Database.shared.deleteAllPosts()

            var postCount = 0

            let filePaths = getDataFilePaths()
            DispatchQueue.main.async {
                progressReader?.fileCountTotal = filePaths.count
            }
            for (index, (filePath, filename)) in filePaths.enumerated() {
                let url = URL(fileURLWithPath: filePath)
                let data = try! Data(contentsOf: url)
                
                let posts = try! Post.decoder.decode([Post].self, from: data)

                let postsWithFilenames = posts.map { post -> Post in
                    var newPost = post
                    newPost.jsFilenameInt = filename.digitsOnlyIntValue
                    return newPost
                }

                try! Database.shared.savePosts(postsWithFilenames)

                postCount += posts.count

                progressReader?.fileCounter.send(index + 1)
                progressReader?.postCounter.send(postCount)
            }
        }
    }

    func getDataFilePaths() -> [(filePath: String, filename: String)] {
        do {
            let filenames = try FileManager.default.contentsOfDirectory(atPath: dataPath)
            return filenames.map { (dataPath + $0, $0) }
        } catch {
            fatalError()
        }
    }
}
