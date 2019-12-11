//
//  PhotoModel.swift
//  FancyGallery
//
//  Created by Mauricio Esteves on 2019-12-10.
//  Copyright © 2019 personal. All rights reserved.
//

import Foundation

class PhotoModel: NSObject {
    
    var id: Int
    var name: String
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}
