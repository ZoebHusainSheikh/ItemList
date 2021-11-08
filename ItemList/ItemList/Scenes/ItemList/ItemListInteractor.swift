//
//  ItemListInteractor.swift
//  ItemList
//
//  Created by Zoeb on 08/11/21.
//

import UIKit

protocol ItemListBusinessLogic
{
    func fetchItems(request: ItemList.Get.Request)
    var item: Item? { get set }
}

protocol ItemListDataStore
{
    var item: Item? { get set }
}

class ItemListInteractor: ItemListBusinessLogic, ItemListDataStore
{
    var item: Item?
    
    var presenter: ItemListPresentationLogic?
    var worker = ItemListWorker()
    
    // MARK: Fetch Items from API
    
    func fetchItems(request: ItemList.Get.Request)
    {
        worker.fetchItems(request: request, { (status, apiResponse) in
            
            let response = ItemList.Get.Response(data: apiResponse as? Data)
            self.presenter?.presentItems(response: response)
        })
        
    }
}
