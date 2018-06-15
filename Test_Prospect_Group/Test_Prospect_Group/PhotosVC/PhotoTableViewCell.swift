//
//  PhotoTableViewCell.swift
//  Test_Prospect_Group
//
//  Created by Maxim Biriukov on 6/8/18.
//  Copyright © 2018 Eugene Chepelev. All rights reserved.
//

import Foundation
import UIKit

class PhotoTableViewCell: UITableViewCell {
    
    //MARK: - Variables
    
    @IBOutlet fileprivate weak var thumbnailImage: UIImageView!
    @IBOutlet fileprivate weak var mainTitle: UILabel!
    @IBOutlet fileprivate weak var hintTitle: UILabel!

    //MARK: - Logic
    
    public func update(with model: Photo) {
        mainTitle.text = "Album id:" + model.albumID
        mainTitle.text = "ID:" + model.id
        
        if let imageURL = model.thumbnailURL {
            thumbnailImage.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "placeholder"), completed: { [weak self] (image, error, type, url) in
                if let image = image {
                    self?.thumbnailImage.image = image
                } else {
                    self?.thumbnailImage.image = UIImage(named: "placeholder")
                }
                //Handle error and customize UI if needed
            })
        }
    }
}
