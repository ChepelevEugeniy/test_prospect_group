//
//  PhotoVC.swift
//  Test_Prospect_Group
//
//  Created by Maxim Biriukov on 6/8/18.
//  Copyright © 2018 Eugene Chepelev. All rights reserved.
//

import UIKit
import SDWebImage

class PhotoVC: UIViewController {
    
    //MARK: - Variables
    
    @IBOutlet fileprivate weak var imageView: UIImageView!
    @IBOutlet fileprivate weak var imageTitle: UILabel!
    
    var model: Photo? = nil
    
    //MARK: - UIViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    //MARK: - Logic
    
    private func setupUI() {
        imageTitle.text = model?.title

        if let imageURL = model?.url {
            imageView.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "placeholder"), completed: { [weak self] (image, error, type, url) in
                if let image = image {
                    self?.imageView.image = image
                } else {
                    self?.imageView.image = UIImage(named: "placeholder")
                }
                //Handle error and customize UI if needed
            })
        }
    }
}
