//
//  OfferentApplicationVC.swift
//  Master247
//
//  Created by Leonardo Barroeta on 3/25/19.
//  Copyright © 2019 Kodim. All rights reserved.
//

import UIKit
import Firebase
import CodableFirebase

class OfferentApplicationVC: UIViewController {

    @IBOutlet weak var sendButton: ActionButton!
    @IBOutlet weak var identificationImage: UIImageView!
    @IBOutlet weak var certificateImage: UIImageView!
    @IBOutlet weak var profileImage: UIImageView!
    
    var addedIdentificationImage: UIImage?
    var addedCertficateImage: UIImage?
    var addedProfileImage: UIImage?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        let tap = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
//        tap.numberOfTapsRequired = 1
        
        addIdentificationImage()
        addCertificateImage()
        addProfileImage()
        
        
    }
    
    @objc func identificationImageTapped() {
        launchImagePicker()
    }
    
    func addIdentificationImage() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(identificationImageTapped))
        tap.numberOfTapsRequired = 1
        identificationImage.isUserInteractionEnabled = true
        identificationImage.clipsToBounds = true
        identificationImage.addGestureRecognizer(tap)
    }
    
    @objc func certificateImageTapped() {
        launchImagePicker()
    }
    
    func addCertificateImage() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(certificateImageTapped))
        tap.numberOfTapsRequired = 1
        certificateImage.isUserInteractionEnabled = true
        certificateImage.clipsToBounds = true
        certificateImage.addGestureRecognizer(tap)
    }
    
    @objc func profileImageTapped() {
        launchImagePicker()
    }
    
    func addProfileImage() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped))
        tap.numberOfTapsRequired = 1
        profileImage.isUserInteractionEnabled = true
        profileImage.clipsToBounds = true
        profileImage.addGestureRecognizer(tap)
    }
    
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func imageTapped() {
        launchImagePicker()
    }
    
    @IBAction func createButtonPressed(_ sender: Any) {
        uploadImageThenDocument()
        sendButton.animateButton(shouldLoad: true, withMessage: nil)
    }
    
    func uploadImageThenDocument() {
        guard let identificationImage = identificationImage.image  else {
            simpleAlert(title: "Campos pendients", msg: "Por favor llene todos los campos.")
            return
        }
        
        
        
        guard let identificationImageData = identificationImage.jpegData(compressionQuality: 0.2) else { return }
        let identificationImageReference  = Storage.storage().reference().child("/applicantImages")
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        identificationImageReference.putData(identificationImageData, metadata: metaData) { (metadata, error) in
            if let error = error {
                self.handleError(error: error, msg: "No pudo ser cargada la imagen.")
                return
            }
            
            identificationImageReference.downloadURL(completion: { (url, error) in
                if let error = error {
                    self.handleError(error: error, msg: "No pudo ser descargada la imagen")
                    return
                }
                
                guard let url = url else { return }
                print(url)
            })
            
        }
    }
    
    func uploadDocument() {
        
    }
    
    func handleError(error: Error, msg: String) {
        debugPrint(error.localizedDescription)
        simpleAlert(title: "Error", msg: msg)
        self.sendButton.animateButton(shouldLoad: false, withMessage: "¡ENVIAR SOLICITUD!")
    }
    
}

extension OfferentApplicationVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func launchImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let identificationImagePicker = info[.originalImage] as? UIImage , let certificateImage = info[.originalImage] as? UIImage else { return }
        
        identificationImage.contentMode = .scaleToFill
        identificationImage.image = identificationImagePicker
        
        profileImage.contentMode = .scaleToFill
        profileImage.image = certificateImage
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}
