//
//  ItemDetailsRouter.swift
//  ItemList
//
//  Created by Zoeb on 09/11/21.
//

import UIKit

protocol ItemDetailsDataPassing
{
  var dataStore: ItemDetailsDataStore? { get }
}

class ItemDetailsRouter: NSObject, ItemDetailsDataPassing
{
  weak var viewController: ItemDetailsViewController?
  var dataStore: ItemDetailsDataStore?
}
