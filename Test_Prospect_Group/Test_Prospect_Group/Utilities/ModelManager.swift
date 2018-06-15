//
//  ModelManager.swift
//  Test_Prospect_Group
//
//  Created by Maxim Biriukov on 6/15/18.
//  Copyright © 2018 Eugene Chepelev. All rights reserved.
//

import Foundation
import Alamofire
import CoreData

protocol ModelManagerDelegate: class {
    func reloadView(with models: [Photo])
    func loadingState()
    func reloadView(with: Error)
}

class ModelManager {
    
    //MARK: - Variables
    
    fileprivate struct Constants {
        static let endpoint = "https://jsonplaceholder.typicode.com/photos"
    }
    
    public weak var delegate: ModelManagerDelegate? = nil
    
    private let reachability = Reachability()
    
    //MARK: - Logic
    
    //FIXME: it will be good to use this method with <T> as a model type with decodable realization
    public func loadData() {
        if Reachability.isConnectedToInternet {
            loadFromNetwork()
        } else {
            loadFromBD()
        }
        
        reachability.listenForReachability { [weak self] reachable in
            if reachable {
                self?.loadFromNetwork()
            }
        }
    }
    
    private func loadFromNetwork() {
        delegate?.loadingState()
        
        Alamofire.request(Constants.endpoint)
            .responseJSON { response in
                // check for errors
                guard response.result.error == nil else {
                    self.delegate?.reloadView(with: response.result.error!)
                    return
                }
                
                guard let json = response.result.value as? [[String: Any]] else {
                    let error = NSError(domain: "Error parsing JSON", code: 400, userInfo:nil)
                    self.delegate?.reloadView(with: error as Error)
                    return
                }
                
                // parse data
                var result: [Photo] = []
                
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
                    result = try JSONDecoder().decode([Photo].self, from: jsonData)
                } catch { print(error) }
                
                self.delegate?.reloadView(with: result)
                self.saveAfterFetching(photos: result)
        }
    }
    
    private func saveAfterFetching(photos: [Photo]) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        if let result = try? managedContext.fetch(PhotoObject.fetchRequest()) {
            for object in result {
                managedContext.delete(object as! NSManagedObject)
            }
        }
        
        //TODO: Perform saving in background thread and background context
        //        DispatchQueue.global(qos: .background).async {
        for photo in photos {
            let photoObject = NSEntityDescription.insertNewObject(forEntityName: "PhotoObject", into: managedContext) as! PhotoObject
            photoObject.albumID = photo.albumID
            photoObject.id = photo.id
            photoObject.title = photo.title
            photoObject.url = photo.thumbnailURL
            photoObject.thumbnailURL = photo.thumbnailURL
        }
        
        do {
            try managedContext.save()
        } catch {
            print(error)
        }
        //        }
    }
    
    private func loadFromBD() {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let managedContext = appDelegate.persistentContainer.viewContext
            
            do {
                let photosObject: [PhotoObject] = try managedContext.fetch(PhotoObject.fetchRequest())
                let photos = Photo.construct(from: photosObject)
                if photos.count > 0 {
                    self.delegate?.reloadView(with: photos)
                } else {
                    let error = NSError(domain: "Empty Database", code: 400, userInfo:nil)
                    self.delegate?.reloadView(with: error)
                }
            } catch let error {
                self.delegate?.reloadView(with: error)
            }
        } else {
            let error = NSError(domain: "Error parsing Database", code: 400, userInfo:nil)
            
            self.delegate?.reloadView(with: error as Error)
        }
    }
}
