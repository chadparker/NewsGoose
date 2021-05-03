//
//  PostNetworkFetcher.swift
//  NewsGoose
//
//  Created by Chad Parker on 4/27/21.
//

import Foundation

public enum PostNetworkError : Error {
    case dataTask(Error)
    case noData
    case parseError(Error)
    case notFound
}

final class PostNetworkFetcher {

    let baseURL = URL(string: "https://hckrnews.com/data/")!

    func fetchLatest(completion: @escaping (Result<[Post], PostNetworkError>) -> Void) {
        let url = baseURL.appendingPathComponent("latest.js")

        URLSession.shared.dataTask(with: url) { data, _, error in
            guard error == nil else {
                DispatchQueue.main.async { completion(.failure(.dataTask(error!))) }
                return
            }
            guard let data = data else {
                DispatchQueue.main.async { completion(.failure(.noData)) }
                return
            }

            do {
                // The `latest.js` file starts with `var entries = `. remove for valid JSON:
                let trimmedData = data.dropFirst(14)
                let posts = try Post.decoder.decode([Post].self, from: trimmedData)

                let postsWithFilenames = posts.map { post -> Post in
                    var newPost = post
                    newPost.js_id = 0
                    return newPost
                }

                DispatchQueue.main.async { completion(.success(postsWithFilenames)) }
            } catch {
                print(error)
                DispatchQueue.main.async { completion(.failure(.parseError(error))) }
            }
        }.resume()
    }

    func fetchDay(_ jsID: Int, completion: @escaping (Result<[Post], PostNetworkError>) -> Void) {
        let url = baseURL.appendingPathComponent("\(jsID).js")

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else {
                DispatchQueue.main.async { completion(.failure(.dataTask(error!))) }
                return
            }
            guard let response = response as? HTTPURLResponse,
                  (200..<300).contains(response.statusCode) else {
                DispatchQueue.main.async { completion(.failure(.notFound)) }
                return
            }
            guard let data = data else {
                DispatchQueue.main.async { completion(.failure(.noData)) }
                return
            }

            do {
                let posts = try Post.decoder.decode([Post].self, from: data)

                let postsWithFilenames = posts.map { post -> Post in
                    var newPost = post
                    newPost.js_id = jsID
                    return newPost
                }

                DispatchQueue.main.async { completion(.success(postsWithFilenames)) }
            } catch {
                print(error)
                DispatchQueue.main.async { completion(.failure(.parseError(error))) }
            }
        }.resume()
    }
}
