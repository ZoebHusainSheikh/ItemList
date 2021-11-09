//
//  ItemListViewController.swift
//  ItemList
//
//  Created by Zoeb on 08/11/21.
//

import UIKit

protocol ItemListDisplayLogic: class
{
    func displayItems(viewModel: ItemList.Get.ViewModel)
    func stopAnimation()
}

class ItemListViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var  activityIndicator: UIActivityIndicatorView!
    
    private enum Constants {
        // cell reuse id (cells that scroll out of view can be reused)
        static let cellReuseIdentifier = ItemListCollectionViewCell.className
        static let rowHeight: CGFloat = 65
        static let baseURL = "https://ey3f2y0nre.execute-api.us-east-1.amazonaws.com/default/dynamodb-writer"
    }
    var items = [Item]()
    private lazy var cellSize = (self.view.frame.width - 30) / 2
    var interactor: ItemListBusinessLogic?
    var router: (NSObjectProtocol & ItemListRoutingLogic & ItemListDataPassing)?
    
    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    // MARK: Setup
    
    private func setup() {
        let viewController = self
        let interactor = ItemListInteractor()
        let presenter = ItemListPresenter()
        let router = ItemListRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
        layout.itemSize = CGSize(width: cellSize, height: cellSize)
        collectionView.collectionViewLayout = layout
        fetchItems()
    }
    
    // MARK: Fetch Items
    
    func fetchItems(url: String = Constants.baseURL) {
        DispatchQueue.main.async {[weak self] in
            self?.activityIndicator.startAnimating()
        }
        let request = ItemList.Get.Request(url: url)
        interactor?.fetchItems(request: request)
    }

}

extension ItemListViewController: ItemListDisplayLogic {
    
    // MARK: ItemList Display Logic
    
    func displayItems(viewModel: ItemList.Get.ViewModel) {
        if let items = viewModel.items {
            self.items = items
        }
        DispatchQueue.main.async {
            self.collectionView.isHidden = false
            self.collectionView.reloadData()
        }
    }
    
    func stopAnimation() {
        self.activityIndicator.stopAnimating()
    }
}

extension ItemListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cellReuseIdentifier, for: indexPath) as? ItemListCollectionViewCell else { return UICollectionViewCell() }
        if items.count > indexPath.row {
            let item = items[indexPath.row]
            cell.update(item)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedItem = items[indexPath.row]
        interactor?.item = selectedItem
        router?.routeToItemDetails()
    }
}
