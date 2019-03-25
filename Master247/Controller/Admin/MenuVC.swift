//
//  MenuVC.swift
//  Master247
//
//  Created by Leonardo Barroeta on 3/19/19.
//  Copyright © 2019 Kodim. All rights reserved.
//

import UIKit

class MenuVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func goToClientsStoryboardButtonPressed(_ sender: Any) {
        presentAdminStoryboard()
    }

    fileprivate func presentAdminStoryboard() {
        let storyboard = UIStoryboard(name: Storyboards.ClientStoryboard, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: ViewControllers.ClientHomeVC)
        present(controller, animated: true, completion: nil)
    }

}
