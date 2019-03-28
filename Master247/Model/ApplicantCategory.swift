//
//  ApplicantCategory.swift
//  Master247
//
//  Created by Leonardo Barroeta on 3/27/19.
//  Copyright © 2019 Kodim. All rights reserved.
//

import Foundation

struct ApplicantCategory {
    var name: String
    var id: String
    
    init(data: [String: Any]) {
        self.name = data["name"] as? String ?? ""
        self.id = data["id"] as? String ?? ""
    }
}
