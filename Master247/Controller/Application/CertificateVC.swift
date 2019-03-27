//
//  CertificateVC.swift
//  Master247
//
//  Created by Leonardo Barroeta on 3/26/19.
//  Copyright © 2019 Kodim. All rights reserved.
//

import UIKit
import Firebase

class CertificateVC: UIViewController {
    
    @IBOutlet weak var certificateImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addCertificateImage()
    }
    
    
    func addCertificateImage() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(certificateImageTapped))
        tap.numberOfTapsRequired = 1
        certificateImage.isUserInteractionEnabled = true
        certificateImage.clipsToBounds = true
        certificateImage.addGestureRecognizer(tap)
    }
    
    @objc func certificateImageTapped() {
        launchImagePicker()
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        uploadImage()
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func uploadImage() {
        guard let currentUser = Auth.auth().currentUser else { return }
        guard let certificateImage = certificateImage.image else { return }
        guard let certificateImageData = certificateImage.jpegData(compressionQuality: 0.2) else { return }
        let certificateImageReference = Storage.storage().reference().child("/certificateImages/\(currentUser.uid)")
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        certificateImageReference.putData(certificateImageData, metadata: metaData) { (metadata, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
                return
            }
            
            certificateImageReference.downloadURL(completion: { (url, error) in
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
            "certificateImageURL": url,
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
 
}

extension CertificateVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func launchImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let certificateImagePicker = info[.originalImage] as? UIImage else { return }
        certificateImage.image = certificateImagePicker
        certificateImage.contentMode = .scaleToFill
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}
