//
//  MainViewModel.swift
//  NewsGoose Importer
//
//  Created by Chad Parker on 5/2/21.
//

import Foundation
import Combine
import NGCore

final class MainViewModel: ObservableObject, ImporterProgress {

    @Published var fileCountProgress = 0
    @Published var fileCountTotal: Int = 0
    @Published var postsImportedCount = 0

    var fileCounter = PassthroughSubject<Int, Never>()
    var postCounter = PassthroughSubject<Int, Never>()
    private var fileCounterSubscriber: AnyCancellable?
    private var postCounterSubscriber: AnyCancellable?

    private let fileCountQueue = DispatchQueue(label: "FileCountQueue", qos: .background)
    private let postCountQueue = DispatchQueue(label: "PostCountQueue", qos: .background)

    init() {
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
}
