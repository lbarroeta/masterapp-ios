//
//  SignUpVC.swift
//  Master247
//
//  Created by Leonardo Barroeta on 3/18/19.
//  Copyright © 2019 Kodim. All rights reserved.
//

import UIKit
import Firebase
import CodableFirebase

class SignUpVC: UIViewController, UITextFieldDelegate {
    
    var database: Firestore!

    
    @IBOutlet weak var nameAndLastnameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var signUpButton: ActionButton!
    @IBOutlet weak var passwordCheckMark: UIImageView!
    @IBOutlet weak var confirmPasswordCheckMark: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboard()
        
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        confirmPasswordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        passwordTextField.text = ""
        confirmPasswordTextField.text = ""
    }
    
    @objc func textFieldDidChange(_ textField: UITextField){
        guard let passwordText = passwordTextField.text else { return }
        
        //If we have started typing in the confirm password text field.
        if textField == confirmPasswordTextField {
            passwordCheckMark.isHidden = false
            confirmPasswordCheckMark.isHidden = false
        } else {
            if passwordText.isEmpty {
                passwordCheckMark.isHidden = true
                confirmPasswordCheckMark.isHidden = true
                confirmPasswordTextField.text = ""
            }
        }
        
        // Make it so when the passwords match, the checkmarks turn green.
        if passwordTextField.text == confirmPasswordTextField.text {
            passwordCheckMark.image = UIImage(named: AppImages.GreenVerifiedMark)
            confirmPasswordCheckMark.image = UIImage(named: AppImages.GreenVerifiedMark)
        } else {
            passwordCheckMark.image = UIImage(named: AppImages.RedVerifiedMark)
            confirmPasswordCheckMark.image = UIImage(named: AppImages.RedVerifiedMark)
        }
        
    }
    
    
    @IBAction func signUpButtonPressed(_ sender: Any) {
        
        guard let email = emailTextField.text , let password = passwordTextField.text , !email.isEmpty , !password.isEmpty else { return }
        
        self.signUpButton.animateButton(shouldLoad: true, withMessage: "")
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if let error = error {
                self.signUpButton.animateButton(shouldLoad: false, withMessage: "¡REGISTRAR!")
                debugPrint(error.localizedDescription)
                self.simpleAlert(title: "Error", msg: "Error al iniciar sesión, intente nuevamente en unos minutos")
                return
            }
            
            self.signUpButton.animateButton(shouldLoad: false, withMessage: "")
            self.createUser()
            self.presentClientStoryboard()
            
        }
        
    }
    
    private func createUser() {
        
        guard let user = Auth.auth().currentUser else { return }
        
        guard let nameAndLastname = nameAndLastnameTextField.text , let phonenumber = phoneNumberTextField.text , let email = emailTextField.text , let password = passwordTextField.text , let confirmPassword = confirmPasswordTextField.text , !nameAndLastname.isEmpty , !email.isEmpty , !phonenumber.isEmpty , !password.isEmpty , !confirmPassword.isEmpty else {
            simpleAlert(title: "Error", msg: "Debe completar todos los campos")
            return
        }
        
        var userData = [String: Any]()
        userData = [
            "nameAndLastname": nameAndLastname,
            "phoneNumber": phonenumber,
            "email": email,
            "role": "client",
            "timestamp": Timestamp()
        ]
        
        Firestore.firestore().collection("users").document(user.uid).setData(userData) { (error) in
            if let error = error {
                debugPrint(error.localizedDescription)
                return
            }
        }
        
    }
    
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    fileprivate func presentClientStoryboard() {
        let storyboard = UIStoryboard(name: Storyboards.ClientStoryboard, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: ViewControllers.ClientHomeVC)
        present(controller, animated: true, completion: nil)
    }

}

