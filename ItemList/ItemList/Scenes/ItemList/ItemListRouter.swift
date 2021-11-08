//
//  ItemListRouter.swift
//  ItemList
//
//  Created by Zoeb on 08/11/21.
//

import UIKit

@objc protocol ItemListRoutingLogic
{
    func routeToItemDetails()
}

protocol ItemListDataPassing
{
    var dataStore: ItemListDataStore? { get }
}

class ItemListRouter: NSObject, ItemListRoutingLogic, ItemListDataPassing {
    weak var viewController: ItemListViewController?
    var dataStore: ItemListDataStore?
    
    // MARK: Routing
    
    func routeToItemDetails() {
        let destinationVC = ItemDetailsViewController()
        var destinationDS = destinationVC.router!.dataStore!
        passDataToItemDetails(source: dataStore!, destination: &destinationDS)
        navigateToItemDetails(source: viewController!, destination: destinationVC)
    }
    
    // MARK: Navigation
    
    func navigateToItemDetails(source: ItemListViewController, destination: ItemDetailsViewController) {
        source.present(destination, animated: true, completion: nil)
    }
    
    // MARK: Passing data
    
    func passDataToItemDetails(source: ItemListDataStore, destination: inout ItemDetailsDataStore) {
        destination.item = source.item
    }
}
