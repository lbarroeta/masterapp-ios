//
//  ClientMenuVC.swift
//  Master247
//
//  Created by Leonardo Barroeta on 3/20/19.
//  Copyright © 2019 Kodim. All rights reserved.
//

import UIKit
import Firebase

class ClientMenuVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func controlPanelButtonPressed(_ sender: Any) {
        presentAdminStoryboard()
    }
    
    fileprivate func presentAdminStoryboard() {
        let storyboard = UIStoryboard(name: Storyboards.AdminStoryboard, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: ViewControllers.AdminDashboardVC)
        present(controller, animated: true, completion: nil)
    }
    
    fileprivate func presentLoginStoryboard() {
        let storyboard = UIStoryboard(name: Storyboards.LoginStoryboard, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: ViewControllers.SignInVC)
        present(controller, animated: true, completion: nil)
    }
    
    @IBAction func signOutButtonPressed(_ sender: Any) {
        try! Auth.auth().signOut()
        self.presentLoginStoryboard()
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
