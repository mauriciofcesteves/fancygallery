//
//  PhotoModel.swift
//  FancyGallery
//
//  Created by Mauricio Esteves on 2019-12-10.
//  Copyright © 2019 personal. All rights reserved.
//

import Foundation

public class PhotoModel: NSObject {
    
    var id: String
    var name: String
    var photoDescription: String
    var photoURL: String?
    
    public init(json: [String: Any]) {
        self.id = ""
        self.name = ""
        self.photoDescription = ""
        
        guard let id = json["uuid"] as? String else {
            return
        }
        
        guard let name = json["title"] as? String else {
            return
        }
        
        guard let description = json["description"] as? String else {
            return
        }
        
        self.id = id
        self.name = name
        self.photoDescription = description
        
        if let photoURL = json["photo_url"] as? String {
            self.photoURL = photoURL
        }
    }

}
