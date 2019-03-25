//
//  CategoriesVC.swift
//  Master247
//
//  Created by Leonardo Barroeta on 3/19/19.
//  Copyright © 2019 Kodim. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class CategoriesVC: UIViewController {
    
    var categories = [Category]()
    var database: Firestore!
    var listener: ListenerRegistration!

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
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
    
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
    

}

extension CategoriesVC: UITableViewDelegate, UITableViewDataSource {
    
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
        if let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.CategoryCell, for: indexPath) as? AdminCategoryCell {
            cell.configureCell(categories: categories[indexPath.item])
            return cell
        }
        return UITableViewCell()
    }
    
    
}
