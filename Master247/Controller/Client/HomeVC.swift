//
//  HomeVC.swift
//  Master247
//
//  Created by Leonardo Barroeta on 3/20/19.
//  Copyright © 2019 Kodim. All rights reserved.
//

import UIKit
import Firebase
import CodableFirebase

class HomeVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var applyButton: ActionButton!
    
    var users = [User]()
    var categories = [Category]()
    var selectedCategory: Category!
    var database: Firestore!
    var listener: ListenerRegistration!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.applyButton.isHidden = true
        
        setUpTableView()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        categoriesListener()
        userRoleListener()
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
    
    func categoriesListener() {
        listener = Firestore.firestore().categories.addSnapshotListener({ (snapshot, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
                return
            }
            
            snapshot?.documentChanges.forEach({ (change) in
                let data = change.document.data()
                let category = Category.init(data: data)
                
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
    
    func userRoleListener() {
        guard let userID = Auth.auth().currentUser else { return }
        Firestore.firestore().collection("users").document(userID.uid).getDocument { (snapshot, error) in
            if let data = snapshot?.data() {
                guard let isAdmin = data["isAdmin"] as? Bool else { return }
                guard let isApproved = data["isApproved"] as? Bool else { return }
                if isAdmin {
                    self.applyButton.isHidden = true
                } else if !isAdmin && !isApproved {
                    self.applyButton.isHidden = false
                    self.applyButton.setTitle("Tu solicitud esta en revisión", for: .normal)
                    self.applyButton.isUserInteractionEnabled = false
                } else if isApproved {
                    self.applyButton.isHidden = true
                }
            }
        }
    }
    
    
}

extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    
    func onCategoryAdded(change: DocumentChange, category: Category) {
        let newIndex = Int(change.newIndex)
        categories.insert(category, at: newIndex)
        tableView.insertRows(at: [IndexPath.init(item: newIndex, section: 0)], with: .automatic)
    }
    
    func onCategoryModified(change: DocumentChange, category: Category) {
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.ClientCategoryCell, for: indexPath) as? CategoryCell {
            cell.configureCell(categories: categories[indexPath.item])
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCategory = categories[indexPath.item]
        performSegue(withIdentifier: Segues.ToOfferents, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.ToOfferents {
            if let destination = segue.destination as? OfferentsVC {
                destination.category = selectedCategory
            }
        }
    }
    
}
