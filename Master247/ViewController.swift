//
//  ViewController.swift
//  Master247
//
//  Created by Leonardo Barroeta on 3/18/19.
//  Copyright © 2019 Kodim. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if Auth.auth().currentUser == nil {
            let storyboard = UIStoryboard(name: Storyboards.LoginStoryboard, bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: ViewControllers.SignInVC)
            present(controller, animated: true, completion: nil)
        } else {
            let storyboard = UIStoryboard(name: Storyboards.ClientStoryboard, bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: ViewControllers.ClientHomeVC)
            present(controller, animated: true, completion: nil)
        }
    }


}

