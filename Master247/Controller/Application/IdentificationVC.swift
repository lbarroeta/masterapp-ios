//
//  IdentificationVC.swift
//  Master247
//
//  Created by Leonardo Barroeta on 3/26/19.
//  Copyright © 2019 Kodim. All rights reserved.
//

import UIKit
import Firebase

class IdentificationVC: UIViewController {

    @IBOutlet weak var identificationImage: UIImageView!
    @IBOutlet weak var sendButton: ActionButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addIdentificationImage()
        
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        uploadImage()
    }
    
    func addIdentificationImage(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(identificationImageTapped))
        tap.numberOfTapsRequired = 1
        identificationImage.isUserInteractionEnabled = true
        identificationImage.clipsToBounds = true
        identificationImage.addGestureRecognizer(tap)
    }
    
    @objc func identificationImageTapped(){
        launchImagePicker()
    }
    
    
    func uploadImage() {
        
        guard let currentUser = Auth.auth().currentUser else { return }
        
        guard let identificationImage = identificationImage.image else {
            simpleAlert(title: "Error", msg: "Debe cargar una foto")
            return
        }
        
        guard let identificationImageData = identificationImage.jpegData(compressionQuality: 0.2) else { return }
        let identificationImageReference = Storage.storage().reference().child("/identificationImages/\(currentUser.uid)")
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        identificationImageReference.putData(identificationImageData, metadata: metaData) { (metadata, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
                return
            }
            
            identificationImageReference.downloadURL(completion: { (url, error) in
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
            "identificationImageURL": url,
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

extension IdentificationVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func launchImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let identificationImagePicker = info[.originalImage] as? UIImage else { return }
        
        identificationImage.contentMode = .scaleToFill
        identificationImage.image = identificationImagePicker
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}
