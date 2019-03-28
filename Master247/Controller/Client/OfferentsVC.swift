//
//  OfferentsVC.swift
//  Master247
//
//  Created by Leonardo Barroeta on 3/27/19.
//  Copyright © 2019 Kodim. All rights reserved.
//

import UIKit
import Firebase

class OfferentsVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var selectedCategory: Category!
    var offerents = [Offerent]()
    var database: Firestore!
    var listener: ListenerRegistration!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        offerentsListener()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        listener.remove()
        offerents.removeAll()
        tableView.reloadData()
    }
    
    func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    func offerentsListener() {
        listener = Firestore.firestore().collection("users").whereField("categories", arrayContains: selectedCategory.name).whereField("isApproved", isEqualTo: true).addSnapshotListener({ (snapshot, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
                return
            }
            
            snapshot?.documentChanges.forEach({ (change) in
                let data = change.document.data()
                let offerent = Offerent.init(data: data)
                
                switch change.type {
                case .added:
                    self.onOfferentAdded(change: change, offerent: offerent)
                case .modified:
                    self.onOfferentModified(change: change, offerent: offerent)
                case .removed:
                    self.onOfferentRemoved(change: change)
                }
                
            })
        })
        
    }
    

    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
}

extension OfferentsVC: UITableViewDelegate, UITableViewDataSource {

    func onOfferentAdded(change: DocumentChange, offerent: Offerent) {
        let newIndex = Int(change.newIndex)
        offerents.insert(offerent, at: newIndex)
        tableView.insertRows(at: [IndexPath.init(item: newIndex, section: 0)], with: .automatic)
    }
    
    func onOfferentModified(change: DocumentChange, offerent: Offerent) {
        if change.newIndex == change.oldIndex {
            let index = Int(change.newIndex)
            offerents[index] = offerent
            tableView.reloadRows(at: [IndexPath(item: index, section: 0)], with: .automatic)
        } else {
            let oldIndex = Int(change.oldIndex)
            let newIndex = Int(change.newIndex)
            offerents.remove(at: oldIndex)
            offerents.insert(offerent, at: newIndex)
            
            tableView.moveRow(at: IndexPath(item: oldIndex, section: 0), to: IndexPath(item: newIndex, section: 0))
        }
    }
    
    func onOfferentRemoved(change: DocumentChange) {
        let oldIndex = Int(change.oldIndex)
        offerents.remove(at: oldIndex)
        tableView.deleteRows(at: [IndexPath.init(item: oldIndex, section: 0)], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return offerents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.OfferentsCell, for: indexPath) as? OfferentCell {
            cell.configureCell(offerents: offerents[indexPath.item])
            return cell
        }
        return UITableViewCell()
    }
    
    
    
    
}
