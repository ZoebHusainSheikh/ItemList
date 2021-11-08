//
//  ItemListWorker.swift
//  ItemList
//
//  Created by Zoeb on 08/11/21.
//

import UIKit

class ItemListWorker
{
    func fetchItems(request: ItemList.Get.Request, _ onCompletion: @escaping CompletionHandler) {
        
        NetworkHttpClient.sharedInstance.performAPICall(request.url, success: { (dataResponse) in
            onCompletion(true, dataResponse)
        }) { (error) in
            print(error as Any)
            onCompletion(false, error)
        }
    }
}
