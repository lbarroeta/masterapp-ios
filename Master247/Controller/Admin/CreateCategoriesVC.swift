//
//  CreateCategoriesVC.swift
//  Master247
//
//  Created by Leonardo Barroeta on 3/19/19.
//  Copyright © 2019 Kodim. All rights reserved.
//

import UIKit
import Firebase
import CodableFirebase
import CropViewController

class CreateCategoriesVC: UIViewController {

    @IBOutlet weak var categoryNameTextField: UITextField!
    @IBOutlet weak var categoryImage: UIImageView!
    
    private var addedCategoryImage: UIImage?
    private var croppingStyle = CropViewCroppingStyle.default
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:)))
        tap.numberOfTapsRequired = 1
        categoryImage.addGestureRecognizer(tap)
        
    }
    
    @objc func imageTapped(_ tap: UITapGestureRecognizer) {
        launchImagePicker()
    }
    
    @IBAction func createButtonPressed(_ sender: Any) {
        guard let image = addedCategoryImage , let categoryName = categoryNameTextField.text , !categoryName.isEmpty else {
            simpleAlert(title: "Error", msg: "Debe agregar una imagen y un nombre para la categoria")
            return
        }
     
        guard let imageData = image.jpegData(compressionQuality: 0.2) else { return }
        let imageReference = Storage.storage().reference().child("categoryImages")
        
        imageReference.putData(imageData, metadata: nil) { (metadata, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
                self.simpleAlert(title: "Error", msg: "No se pudo cargar la imagen")
                return
            }
            
            imageReference.downloadURL(completion: { (url, error) in
                if let error = error {
                    debugPrint(error.localizedDescription)
                    self.simpleAlert(title: "Error", msg: "No se pudo descargar la imagen")
                    return
                }
                
                guard let url = url else { return }
                let newDocumentReference = Firestore.firestore().collection("categories").document()
                let newCategory = AdminCategory.init(name: categoryName, id: newDocumentReference.documentID, imageURL: url.absoluteString, isActive: true)
                
                do {
                    let data = try FirestoreEncoder().encode(newCategory)
                    newDocumentReference.setData(data, completion: { (error) in
                        if let error = error {
                            debugPrint(error.localizedDescription)
                            self.simpleAlert(title: "Error", msg: "No se pudo descargar la data")
                            return
                        }
                        
                        self.dismiss(animated: true, completion: nil)
                    })
                } catch {
                    debugPrint(error.localizedDescription)
                }
                
            })
        }
        
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}

extension CreateCategoriesVC: CropViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func launchImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = (info[UIImagePickerController.InfoKey.originalImage] as? UIImage) else { return }
        
        let cropController = CropViewController(croppingStyle: croppingStyle, image: image)
        cropController.delegate = self
        
        picker.dismiss(animated: true) {
            self.present(cropController, animated: true, completion: nil)
        }
    }
    
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        addedCategoryImage = image
        categoryImage.image = image
        cropViewController.dismiss(animated: true, completion: nil)
    }
    
    
}
