//
//  ItemListModel.swift
//  ItemList
//
//  Created by Zoeb on 08/11/21.
//

import UIKit

enum ItemList
{
    // MARK: Use cases
    
    enum Get
    {
        struct Request
        {
            let url: String
            var params : Dictionary<String, Any>?
        }
        struct Response
        {
            let data: Data?
        }
        struct ViewModel
        {
            var itemsInfo: ItemsResponse?
        }
    }
}

class ItemsResponse: NSObject, Codable {
    var results: [Item]?
}

extension ItemsResponse {
    enum CodingKeys: String, CodingKey {
        case results
    }
}

class Item: NSObject, Codable {
    var createdAt: String?
    var name: String?
    var price: String?
    var uid: String?
    var imageURLs: [String]?
    var imageIDs: [String]?
    var imageURLsThumbnails: [String]?
    
    // To set some different backgrounds
    var bgColors: (UIColor, UIColor)?
}

extension Item {
    enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case name
        case price
        case uid
        case imageURLs = "image_urls"
        case imageIDs = "image_ids"
        case imageURLsThumbnails = "image_urls_thumbnails"
    }
}

extension Item {
    var imageURL: URL? {
        guard let urlString = imageURLs?.first, let url = URL(string: urlString) else { return nil }
        
        return url
    }
    var imageThumbnailURL: URL? {
        guard let urlString = imageURLsThumbnails?.first, let url = URL(string: urlString) else { return nil }
        
        return url
    }
    
    var colors: (UIColor, UIColor)? {
        if self.bgColors == nil {
            self.bgColors = Item.colorOptions.randomElement()
        }
        
        return self.bgColors
    }
    
    private static var colorOptions: [(UIColor, UIColor)] = {
        var colorOptionList = [(UIColor, UIColor)]()
        colorOptionList.append((UIColor(hex: "#48D0B0"), UIColor(hex: "#5EDFC5")))
        colorOptionList.append((UIColor(hex: "#F76362"), UIColor(hex: "#FA8585")))
        colorOptionList.append((UIColor(hex: "#76BDFE"), UIColor(hex: "#8FD0FE")))
        colorOptionList.append((UIColor(hex: "#FED86F"), UIColor(hex: "#FBE17C")))
        return colorOptionList
    }()
}

