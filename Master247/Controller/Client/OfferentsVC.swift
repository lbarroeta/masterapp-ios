//
//  OfferentsVC.swift
//  Master247
//
//  Created by Leonardo Barroeta on 3/21/19.
//  Copyright © 2019 Kodim. All rights reserved.
//

import UIKit
import Firebase

class OfferentsVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var workers = [Worker]()
    var category: Category!
    var database: Firestore!
    var listener: ListenerRegistration!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTableView()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        workersListener()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        listener.remove()
        
        tableView.reloadData()
    }
    
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func workersListener() {

        listener = Firestore.firestore().workers.whereField("category", arrayContains: category.id).order(by: "timestamp", descending: false).addSnapshotListener({ (snapshot, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
                return
            }

            snapshot?.documentChanges.forEach({ (change) in
                let data = change.document.data()
                let worker = Worker.init(data: data)

                switch change.type {
                case .added:
                    self.onCategoryAdded(change: change, worker: worker)
                case .modified:
                    self.onCategoryModified(change: change, worker: worker)
                case .removed:
                    self.onCategoryRemoved(change: change)
                }
            })
        })

    }
    
}

extension OfferentsVC: UITableViewDelegate, UITableViewDataSource {
    
    func onCategoryAdded(change: DocumentChange, worker: Worker) {
        let newIndex = Int(change.newIndex)
        workers.insert(worker, at: newIndex)
        tableView.insertRows(at: [IndexPath.init(item: newIndex, section: 0)], with: .automatic)
    }

    func onCategoryModified(change: DocumentChange, worker: Worker) {
        if change.newIndex == change.oldIndex {
            let index = Int(change.newIndex)
            workers[index] = worker
            tableView.reloadRows(at: [IndexPath(item: index, section: 0)], with: .automatic)
        } else {
            let oldIndex = Int(change.oldIndex)
            let newIndex = Int(change.newIndex)
            workers.remove(at: oldIndex)
            workers.insert(worker, at: newIndex)
            tableView.moveRow(at: IndexPath(item: oldIndex, section: 0), to: IndexPath(item: newIndex, section: 0))
        }
    }

    func onCategoryRemoved(change: DocumentChange) {
        let oldIndex = Int(change.oldIndex)
        workers.remove(at: oldIndex)
        tableView.deleteRows(at: [IndexPath.init(item: oldIndex, section: 0)], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.OfferentsCell, for: indexPath) as? OfferentCell {
            
            return cell
        }
        return UITableViewCell()
    }
    
    
}
