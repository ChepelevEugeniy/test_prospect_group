//
//  PhotosVC.swift
//  Test_Prospect_Group
//
//  Created by Maxim Biriukov on 6/8/18.
//  Copyright © 2018 Eugene Chepelev. All rights reserved.
//

import UIKit

class PhotosVC: UIViewController {
    
    //MARK: - Variables
    
    fileprivate struct Constants {
        static let tableRowHeight: CGFloat = 166
    }
    
    @IBOutlet fileprivate weak var tableView: UITableView!
    
    @IBOutlet fileprivate weak var errorView: UIView!
    @IBOutlet fileprivate weak var errorLabel: UILabel!
    
    fileprivate var photos: [Photo] = []
    
    private lazy var modelManager: ModelManager = { [weak self] in
        let manager = ModelManager()
        manager.delegate = self
        return manager
        }()
    
    //MARK: - UIViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = Constants.tableRowHeight
        errorView.isHidden = false
        
        modelManager.loadData()
    }
    
    //MARK: - Logic
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let selectedIndex = tableView.indexPathForSelectedRow?.row
        if let photoVC = segue.destination as? PhotoVC, let index = selectedIndex {
            photoVC.model = photos[index]
        }
    }
    
    fileprivate func startFlashing() {
        UIView.animate(withDuration: 1.0, delay: 0, options: [.repeat, .autoreverse, .beginFromCurrentState], animations: {
            self.errorLabel.alpha = 0.0
        }, completion: nil)
    }
    
    fileprivate func stopFlashing() {
        view.layer.removeAllAnimations()
    }
}

//MARK: - ModelManagerDelegate

extension PhotosVC: ModelManagerDelegate {
    
    func reloadView(with models: [Photo]) {
        self.errorView.isHidden = true
        self.photos = models.sorted { $0.id < $1.id }
        self.tableView.reloadData()
        
        stopFlashing()
    }
    
    func reloadView(with error: Error) {
        self.errorView.isHidden = false
        self.errorLabel.text = error.localizedDescription
        
        stopFlashing()
    }
    
    func loadingState() {
        errorView.isHidden = false
        errorLabel.text = "Loading..."
        
        self.startFlashing()
    }
}

//MARK: - TableView delegate and datasource

extension PhotosVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let photosCell: PhotoTableViewCell = tableView.dequeueReusableCell(withIdentifier: "PhotosCell", for: indexPath) as! PhotoTableViewCell
        
        photosCell.update(with: photos[indexPath.row])
        
        return photosCell
    }
}
