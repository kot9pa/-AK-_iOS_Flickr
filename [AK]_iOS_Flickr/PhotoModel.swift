//
//  PhotoModel.swift
//  [AK]_iOS_Flickr
//
//  Created by Konstantin on 20.10.2018.
//  Copyright © 2018 Konstantin. All rights reserved.
//

import Foundation
import SwiftyJSON

var photos = [URL]()

struct PhotoModel {
    var farm: Int
    var server: String
    var id: String
    var secret: String
    var size = "m" //small, 240 on longest side
    
    init?(json: JSON) {
        guard
            let farm = json["farm"].int,
            let server = json["server"].string,
            let id = json["id"].string,
            let secret = json["secret"].string
        else { return nil }
        
        self.farm = farm
        self.server = server
        self.id = id
        self.secret = secret
    }
    
    static func createURL(from jsonData: Any) -> [URL]? {
        let json = JSON(jsonData)
        let data = json["photos"]["photo"].array
        guard let jsonArray = data else { return nil }
        for jsonObject in jsonArray {
            guard let photo = PhotoModel(json: jsonObject) else { continue }
            let photoURL = "https://farm\(photo.farm).staticflickr.com/\(photo.server)/\(photo.id)_\(photo.secret)_\(photo.size).jpg"
            photos.append(URL(string: photoURL)!)
        }

        return photos
    }
}

struct Photos {
    static func getCount(from jsonData: Any) -> Int? {
        let json = JSON(jsonData)
        if let data = json["photos"]["total"].int {
            return data
        } else {
            return nil
        }
    }        
}
