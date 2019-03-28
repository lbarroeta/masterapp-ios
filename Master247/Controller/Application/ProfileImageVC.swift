//
//  ProfileImageVC.swift
//  Master247
//
//  Created by Leonardo Barroeta on 3/26/19.
//  Copyright © 2019 Kodim. All rights reserved.
//

import UIKit
import Firebase

class ProfileImageVC: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addProfileImage()
    }
    
    func addProfileImage() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped))
        tap.numberOfTapsRequired = 1
        profileImage.isUserInteractionEnabled = true
        profileImage.clipsToBounds = true
        profileImage.addGestureRecognizer(tap)
    }
    
    @objc func profileImageTapped() {
        launchImagePicker()
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        uploadImage()
    }
    
    func uploadImage() {
        guard let currentUser = Auth.auth().currentUser else { return }
        guard let profileImage = profileImage.image else { return }
        guard let profileImageData = profileImage.jpegData(compressionQuality: 0.2) else { return }
        
        let profileImageReference = Storage.storage().reference().child("/profileImages/\(currentUser.uid)")
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        profileImageReference.putData(profileImageData, metadata: metaData) { (metadata, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
                return
            }
            
            profileImageReference.downloadURL(completion: { (url, error) in
                if let error = error {
                    debugPrint(error.localizedDescription)
                    return
                }
                
                guard let url = url else { return }
                self.uploadDocument(url: url.absoluteString)
            })
        }
    }
    
    func uploadDocument(url: String) {
        guard let user = Auth.auth().currentUser else { return }
        var docRef: DocumentReference!
        var userData = [String : Any]()
        userData = [
            "profileImageURL": url,
            "isApproved": false,
            "role": "offerent",
        ]
        
        docRef = Firestore.firestore().collection("users").document(user.uid)
        
        let data = userData
        docRef.setData(data, merge: true) { (error) in
            if let error = error {
                debugPrint(error.localizedDescription)
                return
            }
        }
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

}

extension ProfileImageVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func launchImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let profileImagePicker = info[.originalImage] as? UIImage else { return }
        profileImage.image = profileImagePicker
        profileImage.contentMode = .scaleToFill
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
