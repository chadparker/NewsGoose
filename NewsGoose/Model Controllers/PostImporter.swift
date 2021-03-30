//
//  PostImporter.swift
//  NewsGoose
//
//  Created by Chad Parker on 3/29/21.
//

import Foundation
import CoreData

class PostImporter {
    
    init() {
        if getCoreDataCount() == 0 {
            importJSToCoreData()
        }
    }
    
    func importJSToCoreData() {
        print("Importing...")
        var idsSeen = Set<String>()
        
        for filePath in getDataFilePaths() {
            
            let url = URL(fileURLWithPath: filePath)
            let data = try! Data(contentsOf: url)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .secondsSince1970
            let postReps = try! decoder.decode([PostRepresentation].self, from: data)
            
            // save posts to Core Data
            for postRep in postReps {
                if !idsSeen.contains(postRep.id) {
                    Post(movieRepresentation: postRep)
                    idsSeen.insert(postRep.id)
                }
            }
            
            try! CoreDataStack.shared.save()
        }
        print("idsSeen count:")
        print(idsSeen.count)
        
        print("In Core Data:")
        print(getCoreDataCount())
    }
    
    private func getCoreDataCount() -> Int {
        let fetchRequest: NSFetchRequest<Post> = Post.fetchRequest()
        let context = CoreDataStack.shared.mainContext
        let existingPosts = try! context.fetch(fetchRequest)
        return existingPosts.count
    }
    
    private func getDataFilePaths() -> [String] {
        let path = "\(Bundle.main.resourcePath!)/data/"
        
        do {
            let filenames = try FileManager.default.contentsOfDirectory(atPath: path)
            return filenames.map { path + $0 }
        } catch {
            fatalError()
        }
    }
}
