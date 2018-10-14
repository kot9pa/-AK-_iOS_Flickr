//
//  CameraModel.swift
//  [AK]_iOS_Flickr
//
//  Created by Konstantin on 13.10.2018.
//  Copyright © 2018 Konstantin. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Detail {
    var lcd_screen_size: String
    var megapixels: String
    var memory_type: String
    
    init(json: JSON) {
        let lcd_screen_size = json["details"]["lcd_screen_size"]["_content"].string
        let megapixels = json["details"]["megapixels"]["_content"].string
        let memory_type = json["details"]["memory_type"]["_content"].string
        
        self.lcd_screen_size = lcd_screen_size ?? ""
        self.megapixels = megapixels ?? ""
        self.memory_type = memory_type ?? ""
    }
}

struct CameraModel {
    var name: String
    var images: String
    var details: Detail?
    
    init(json: JSON) {
        let name = json["name"]["_content"].string
        let images = json["images"]["small"]["_content"].string
        
        self.name = name ?? ""
        self.images = images ?? ""
    }
    
    init(json: JSON, details: Detail) {
        let name = json["name"]["_content"].string
        let images = json["images"]["large"]["_content"].string
        
        self.name = name ?? ""
        self.images = images ?? ""
        self.details = details
    }
    
    static func createModel(from jsonData: Any) -> [CameraModel]? {
        var cameras = [CameraModel]()
        let json = JSON(jsonData)
        let data = json["cameras"]["camera"].array
        guard let jsonArray = data else { return nil }
        //print(jsonArray)
        for jsonObject in jsonArray {
            if jsonObject["details"].isEmpty {
                let camera = CameraModel(json: jsonObject)
                cameras.append(camera)
            } else {
                let camera = CameraModel(json: jsonObject, details: Detail(json: jsonObject))
                cameras.append(camera)
            }
        }
        //dump(cameras)
        return cameras
        
    }
    
}
