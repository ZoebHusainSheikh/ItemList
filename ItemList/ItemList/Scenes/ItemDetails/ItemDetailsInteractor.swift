//
//  ItemDetailsInteractor.swift
//  ItemList
//
//  Created by Zoeb on 09/11/21.
//

import UIKit

protocol ItemDetailsBusinessLogic
{
    var item: Item? { get set }
}

protocol ItemDetailsDataStore
{
    var item: Item? { get set }
}

class ItemDetailsInteractor: ItemDetailsBusinessLogic, ItemDetailsDataStore
{
    var item: Item?
}

