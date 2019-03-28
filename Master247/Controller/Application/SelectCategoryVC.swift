//
//  SelectCategoryVC.swift
//  Master247
//
//  Created by Leonardo Barroeta on 3/26/19.
//  Copyright © 2019 Kodim. All rights reserved.
//

import UIKit
import Firebase

class SelectCategoryVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var chosenCategoriesLabel: UILabel!
    @IBOutlet weak var nextButton: ActionButton!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var categories = [ApplicantCategory]()
    var database: Firestore!
    var listener: ListenerRegistration!
    
    var searchCategory = [String]()
    var chosenCategoryArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpTableView()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        nextButton.isHidden = true
        categoriesListener()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        listener.remove()
        categories.removeAll()
        tableView.reloadData()
    }
    
    func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        addCategoriesToUser()
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func categoriesListener() {
        listener = Firestore.firestore().categories.addSnapshotListener({ (snapshot, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
                return
            }
            
            for document in snapshot!.documents {
                print(document.documentID)
            }
            
            snapshot?.documentChanges.forEach({ (change) in
                let data = change.document.data()
                let category = ApplicantCategory.init(data: data)
                
                switch change.type {
                case .added:
                    self.onCategoryAdded(change: change, category: category)
                case .modified:
                    self.onCategoryModified(change: change, category: category)
                case .removed:
                    self.onCategoryRemoved(change: change)
                }
            })
            
        })
    }
    
    func addCategoriesToUser() {
        guard let user = Auth.auth().currentUser else { return }
    
        
        var userData = [String: Any]()
        userData = [
            "categories": chosenCategoryArray
        ]
        
        Firestore.firestore().collection("users").document(user.uid).setData(userData, merge: true) { (error) in
            if let error = error {
                debugPrint(error.localizedDescription)
                return
            }
        }
    
    }
    

}

extension SelectCategoryVC: UITableViewDelegate, UITableViewDataSource {
    
    func onCategoryAdded(change: DocumentChange, category: ApplicantCategory) {
        let newIndex = Int(change.newIndex)
        categories.insert(category, at: newIndex)
        tableView.insertRows(at: [IndexPath.init(item: newIndex, section: 0)], with: .automatic)
    }
    
    func onCategoryModified(change: DocumentChange, category: ApplicantCategory) {
        if change.newIndex == change.oldIndex {
            // Item changed, but remained in the same position.
            let index = Int(change.newIndex)
            categories[index] = category
            tableView.reloadRows(at: [IndexPath(item: index, section: 0)], with: .automatic)
        } else {
            // Item changed and changed the position.
            let oldIndex = Int(change.oldIndex)
            let newIndex = Int(change.newIndex)
            categories.remove(at: oldIndex)
            categories.insert(category, at: newIndex)
            
            tableView.moveRow(at: IndexPath(item: oldIndex, section: 0), to: IndexPath(item: newIndex, section: 0))
            
        }
    }
    
    func onCategoryRemoved(change: DocumentChange) {
        let oldIndex = Int(change.oldIndex)
        categories.remove(at: oldIndex)
        tableView.deleteRows(at: [IndexPath.init(item: oldIndex, section: 0)], with: .automatic)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.ApplicantCategoryCell, for: indexPath) as? ApplicantCategoryCell {
            cell.configureCell(categories: categories[indexPath.item])
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? ApplicantCategoryCell else { return }
        // Not adding twice a category
        if !chosenCategoryArray.contains(cell.categoryTitle.text!) {
            chosenCategoryArray.append(cell.categoryTitle.text!)
            chosenCategoriesLabel.text = chosenCategoryArray.joined(separator: ", ")
            nextButton.isHidden = false
        } else {
            chosenCategoryArray = chosenCategoryArray.filter({ $0 != cell.categoryTitle.text! })
            if chosenCategoryArray.count >= 1 {
                chosenCategoriesLabel.text = chosenCategoryArray.joined(separator: ", ")
            } else {
                chosenCategoriesLabel.text = "Haz clic sobre una categoria y aqui se listaran todas las que selecciones"
                nextButton.isHidden = true
            }
        }
    }
    
}

