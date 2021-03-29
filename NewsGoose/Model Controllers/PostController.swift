//
//  PostController.swift
//  NewsGoose
//
//  Created by Chad Parker on 3/29/21.
//

import Foundation
import CoreData

class PostController {
    
    init() {
        saveToCoreData()
        
        let fetchRequest: NSFetchRequest<Post> = Post.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        let context = CoreDataStack.shared.mainContext
        
        let existingPosts = try! context.fetch(fetchRequest)
        
        print("In Core Data:")
        print(existingPosts.count)
        
        
    }
    
    func saveToCoreData() {
        
        var idsSeen = Set<String>()
        
        for filePath in getDataFilePaths() {
            
            let url = URL(fileURLWithPath: filePath)
            let data = try! Data(contentsOf: url)
            let postReps = try! JSONDecoder().decode([PostRepresentation].self, from: data)
            
            // save posts to Core Data
            for postRep in postReps {
                if !idsSeen.contains(postRep.id) {
                    Post(movieRepresentation: postRep)
                    idsSeen.insert(postRep.id)
                }
            }
            
            try! CoreDataStack.shared.save()
            
            //print(filePath)
            //print("saved")
            //print(idsSeen.sorted())
            
            //break
        }
        print("idsSeen count:")
        print(idsSeen.count)
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
