//
//  PhotosVC.swift
//  Test_Prospect_Group
//
//  Created by Maxim Biriukov on 6/8/18.
//  Copyright © 2018 Eugene Chepelev. All rights reserved.
//

import UIKit
import Alamofire

class PhotosVC: UIViewController {
    
    //MARK: - Variables
    
    @IBOutlet fileprivate weak var tableView: UITableView!
    
    @IBOutlet fileprivate weak var errorView: UIView!
    @IBOutlet fileprivate weak var errorLabel: UILabel!
    
    let photos: [Photo] = []
    
    //MARK: - UIViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        errorView.isHidden = false
        
        loadData()
    }
    
    //MARK: - Functionality
    
    private func loadData() {
        let photosEndpoint: String = "https://jsonplaceholder.typicode.com/photos"
        Alamofire.request(photosEndpoint)
            .responseJSON { response in
                // check for errors
                guard response.result.error == nil else {
                    // got an error in getting the data, need to handle it
                    print("error calling GET on /todos/1")
                    print(response.result.error!)
                    return
                }
                
                // make sure we got some JSON since that's what we expect
                guard let json = response.result.value as? [[String: Any]] else {
                    print("didn't get todo object as JSON from API")
                    if let error = response.result.error {
                        print("Error: \(error)")
                    }
                    return
                }
                
                // get and print the title
                guard let todoTitle = json[0]["title"] as? String else {
                    print("Could not get todo title from JSON")
                    return
                }
                print("The title is: " + todoTitle)
        }
    }
}

extension PhotosVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let photosCell = tableView.dequeueReusableCell(withIdentifier: "PhotosCell", for: indexPath)
        return photosCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("select")
    }
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        super.prepare(for: segue, sender: sender)
//
//        guard let photoVC = segue.destination as? PhotoVC else { return }
//
//        photoVC.model = photos
//    }
}
