//
//  Worker.swift
//  Master247
//
//  Created by Leonardo Barroeta on 3/25/19.
//  Copyright © 2019 Kodim. All rights reserved.
//

import Foundation

struct Worker {
    var name: String
    var id: String
    var imageURL: String
    var isActive: Bool = true
    
    init(data: [String: Any]) {
        self.name = data["name"] as? String ?? ""
        self.id = data["id"] as? String ?? ""
        self.imageURL = data["imageURL"] as? String ?? ""
        self.isActive = data["isActive"] as? Bool ?? true
    }
}
