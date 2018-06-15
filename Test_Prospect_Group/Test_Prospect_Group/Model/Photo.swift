//
//  Photo.swift
//  Test_Prospect_Group
//
//  Created by Maxim Biriukov on 6/8/18.
//  Copyright © 2018 Eugene Chepelev. All rights reserved.
//

import Foundation

struct Photo: Decodable {
    
    //MARK: - Variables
    
    var albumID: String = ""
    var id: String = ""
    var title: String = ""
    var url: URL?
    var thumbnailURL: URL?
    
    //MARK: - Logic
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let albumID: String = try String(container.decode(Int.self, forKey: .albumID))
        let id: String = try String(container.decode(Int.self, forKey: .id))
        let title: String = try container.decode(String.self, forKey: .title)
        let url: URL = try container.decode(URL.self, forKey: .url)
        let thumbnailURL: URL = try container.decode(URL.self, forKey: .thumbnailURL)
        
        self.init(albumID: albumID, id: id, title: title, url: url, thumbnailURL: thumbnailURL)
    }
    
    init(albumID: String, id: String, title: String, url: URL?, thumbnailURL: URL?) {
        self.albumID = albumID
        self.id = id
        self.title = title
        self.url = url
        self.thumbnailURL = thumbnailURL
    }
    
    private enum CodingKeys : String, CodingKey {
        case albumID = "albumId"
        case id
        case title
        case url
        case thumbnailURL = "thumbnailUrl"
    }
    
    //MARK: CoreDataStack
    
    static func construct(from objects: [PhotoObject]) -> [Photo] {
        return objects
            .enumerated()
            .map { object in
                let albumID = object.element.albumID ?? ""
                let id = object.element.id ?? ""
                let title = object.element.title ?? ""
                let url = object.element.url
                let thumbnailURL = object.element.thumbnailURL
                
                return Photo(albumID: albumID, id: id, title: title, url: url, thumbnailURL: thumbnailURL)
        }
    }

}
