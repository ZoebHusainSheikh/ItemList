//
//  ItemListPresenter.swift
//  ItemList
//
//  Created by Zoeb on 08/11/21.
//

import UIKit

protocol ItemListPresentationLogic
{
    func presentItems(response: ItemList.Get.Response)
}

class ItemListPresenter: ItemListPresentationLogic
{
    weak var viewController: ItemListDisplayLogic?
    
    // MARK: Mapping
    
    func presentItems(response: ItemList.Get.Response)
    {
        if let dataResponse = response.data {
            do {
                //here dataResponse received from a network request
                let decoder = JSONDecoder()
                let model = try decoder.decode(ItemsResponse.self, from:
                    dataResponse) //Decode JSON Response Data
                let results = model.results?.sorted(by: { (item1, item2) -> Bool in
                    item1.name ?? String.empty < item2.name ?? String.empty
                })
                
                DispatchQueue.main.async { [weak self] in
                    self?.viewController?.displayItems(viewModel: ItemList.Get.ViewModel(items: results))
                    self?.viewController?.stopAnimation()
                }
            } catch let parsingError {
                print("Error", parsingError)
                AlertViewController.sharedInstance.alertWindow(message: parsingError.localizedDescription)
            }
        } else {
            DispatchQueue.main.async { [weak self] in
                self?.viewController?.stopAnimation()
            }
        }
    }
}
