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
        //saveToCoreData()
    }
    
    func saveToCoreData() {
        
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
        
        printObjectCount()
    }
    
    private func printObjectCount() {
        NSLog("start")
        let fetchRequest: NSFetchRequest<Post> = Post.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        let context = CoreDataStack.shared.mainContext
        
        let existingPosts = try! context.fetch(fetchRequest)
        
        print("In Core Data:")
        print(existingPosts.count)
        
        NSLog("end")
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
