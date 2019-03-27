//
//  Applicant.swift
//  Master247
//
//  Created by Leonardo Barroeta on 3/25/19.
//  Copyright © 2019 Kodim. All rights reserved.
//

import Foundation

struct Applicant : Codable {
    var identificationImageURL: String = ""
    var profileImageURL: String = ""
    var professionalCertificateImageURL: String = ""
    var isAproved: Bool = true
}
