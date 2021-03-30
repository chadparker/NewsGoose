//
//  Post+Convenience.swift
//  NewsGoose
//
//  Created by Chad Parker on 3/29/21.
//

import Foundation
import CoreData

extension Post {
    
    @discardableResult convenience init(id: String,
                                        
                                        link_text: String,
                                        link: String,
                                        submitter: String,
                                        
                                        type: String?,
                                        source: String?,
                                        dead: Bool,
                                        
                                        points: Int?,
                                        comments: Int?,
                                        
                                        date: Date,
                                        time: Date?,
                                        
                                        day: Date,
                                        context: NSManagedObjectContext) {
        
        self.init(context: context)
        
        self.id = id
        
        self.link_text = link_text
        self.link = link
        self.submitter = submitter
        
        self.type = type
        self.source = source
        self.dead = dead
        
        if points != nil {
            self.points = Int16(points!)
        }
        if comments != nil {
            self.comments = Int16(comments!)
        }
        
        self.date = date
        if time != nil {
            self.time = time
        }
        
        self.day = day
    }
    
    @discardableResult convenience init?(
        movieRepresentation: PostRepresentation,
        calendar: Calendar,
        context: NSManagedObjectContext = CoreDataStack.shared.mainContext
    ) {
    
        self.init(id: movieRepresentation.id,
                  
                  link_text: movieRepresentation.link_text,
                  link: movieRepresentation.link,
                  submitter: movieRepresentation.submitter,
                  
                  type: movieRepresentation.type,
                  source: movieRepresentation.source,
                  dead: movieRepresentation.dead,
                  
                  points: movieRepresentation.points,
                  comments: movieRepresentation.comments,
                  
                  date: movieRepresentation.date,
                  time: movieRepresentation.time,
                  
                  day: calendar.startOfDay(for: movieRepresentation.date),
                  
                  context: context)
    }
}

extension Post {
    
    @objc var dayFormatted: String {
        Constants.dateFormatter.string(from: self.day!)
    }
}
