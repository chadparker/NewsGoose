//
//  PostFetcherTests.swift
//  
//
//  Created by Chad Parker on 4/30/21.
//

import XCTest
@testable import NGCore

final class PostFetcherTests: XCTestCase {

    var sut: PostFetcher!

    override func setUp() {
        sut = PostFetcher()
    }

    override func tearDown() {
        sut = nil
    }

    func testFetchLatest() {
        let expectation = self.expectation(description: "Waiting for PostFetcher")
        sut.fetchLatest { result in
            switch result {
            case .success(let posts):
                print("✅\(posts.count) posts fetched")
                XCTAssertGreaterThan(posts.count, 10)
            case .failure(let networkError):
                print("🛑Error: \(networkError)")
                XCTFail()
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
    }

    func testFetchDay() {
        let expectation = self.expectation(description: "Waiting for PostFetcher")
        sut.fetchDay("20200425") { result in
            switch result {
            case .success(let posts):
                print("✅\(posts.count) posts fetched")
                XCTAssertGreaterThan(posts.count, 10)
            case .failure(let networkError):
                print("🛑Error: \(networkError)")
                XCTFail()
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
    }
}
