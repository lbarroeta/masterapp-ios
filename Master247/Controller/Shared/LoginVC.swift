//
//  LoginVC.swift
//  Master247
//
//  Created by Leonardo Barroeta on 3/18/19.
//  Copyright © 2019 Kodim. All rights reserved.
//

import UIKit
import Firebase

class LoginVC: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: ActionButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboard()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signInButtonPressed(_ sender: Any) {
        
        guard let email = emailTextField.text , let password = passwordTextField.text , !email.isEmpty , !password.isEmpty else {
            simpleAlert(title: "Error", msg: "Debe completar todos los campos")
            return
        }
        
        signInButton.animateButton(shouldLoad: true, withMessage: nil)
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
                return
            }
            
            self.presentClientStoryboard()
        }
        
    }
    
    fileprivate func presentClientStoryboard() {
        let storyboard = UIStoryboard(name: Storyboards.ClientStoryboard, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: ViewControllers.ClientHomeVC)
        present(controller, animated: true, completion: nil)
    }

}
