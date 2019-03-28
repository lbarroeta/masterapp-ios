//
//  Constants.swift
//  Master247
//
//  Created by Leonardo Barroeta on 3/19/19.
//  Copyright © 2019 Kodim. All rights reserved.
//

import Foundation

struct Storyboards {
    static let LoginStoryboard = "LoginStoryboard"
    static let AdminStoryboard = "AdminStoryboard"
    static let ClientStoryboard = "ClientStoryboard"
}

struct ViewControllers {
    // SIGN IN VC
    static let SignInVC = "SignInVC"
    
    // Clients VC
    static let ClientHomeVC = "ClientHomeVC"
    
    // ADMINS VC
    static let AdminDashboardVC = "AdminDashboardVC"
    
}

struct Segues {
    static let ToOfferents = "ToOfferentsVC"
}

struct CellIdentifiers {
    static let ClientCategoryCell = "ClientCategoryCell"
    static let OfferentsCell = "OfferentsCell"
    static let CategoryCell = "CategoryCell"
    static let ApplicantCategoryCell = "ApplicantCategoryCell"
}

struct AppImages {
    static let GreenVerifiedMark = "GreenVerifiedMark"
    static let RedVerifiedMark = "RedVerifiedMark"
}
