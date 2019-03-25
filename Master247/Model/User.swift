//
//  User.swift
//  Master247
//
//  Created by Leonardo Barroeta on 3/23/19.
//  Copyright © 2019 Kodim. All rights reserved.
//

import Foundation

struct User : Codable {
    var nameAndLastname: String = ""
    var password: String = ""
    var id: String = ""
    var email: String = ""
    var isAdmin: Bool = false
    var phoneNumber: String = ""
}
