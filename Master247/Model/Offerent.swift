//
//  Offerent.swift
//  Master247
//
//  Created by Leonardo Barroeta on 3/27/19.
//  Copyright © 2019 Kodim. All rights reserved.
//

import Foundation

struct Offerent : Codable {
    var nameAndLastname: String = ""
    var profileImageURL: String = ""
    var isApproved: Bool = true
    
    init(data: [String: Any]) {
        self.nameAndLastname = data["nameAndLastname"] as? String ?? ""
        self.profileImageURL = data["profileImageURL"] as? String ?? ""
        self.isApproved = data["isApproved"] as? Bool ?? true
    }
}
