//
//  FirebaseUtilities.swift
//  Master247
//
//  Created by Leonardo Barroeta on 3/19/19.
//  Copyright © 2019 Kodim. All rights reserved.
//

import Firebase
import FirebaseFirestore

extension Firestore {
    var categories: Query {
        return collection("categories").order(by: "name", descending: false).whereField("isActive", isEqualTo: true)
//        return collection("categories").order(by: "rating", descending: true).order(by: "name", descending: false).whereField("isActive", isEqualTo: true)
    }
    
    var workers: CollectionReference {
        return collection("users")
    }
    
    var applicantCategories: Query {
        return collection("categories").order(by: "name", descending: false).whereField("isActive", isEqualTo: true)
    }
    
}
