//
//  ItemDetailsViewController.swift
//  ItemList
//
//  Created by Zoeb on 08/11/21.
//

import UIKit

class ItemDetailsViewController: UIViewController
{
    private var item: Item?
    var interactor: ItemDetailsBusinessLogic?
    var router: (NSObjectProtocol & ItemDetailsDataPassing)?
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
    {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup()
    {
        let viewController = self
        let interactor = ItemDetailsInteractor()
        let router = ItemDetailsRouter()
        viewController.interactor = interactor
        viewController.router = router
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        initialiseView()
    }
    
    // MARK: - UI elements
    
    lazy var headerView: UIView = {
       let view = UIView()
        view.clipsToBounds = true
        return view
    }()
    
    lazy var detailsView: UIView = {
       let view = UIView()
        view.backgroundColor = .white
        view.cornerRadius = 30
        view.clipsToBounds = true
        return view
    }()
    
    lazy var itemImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 40)
        label.minimumScaleFactor = 0.5
        label.sizeToFit()
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()
    
    lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    lazy var uidLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.textAlignment = .left
        return label
    }()
}

private extension ItemDetailsViewController {
    
    func initialiseView() {
        self.view.backgroundColor = .white
        setupUI()
        displayItemDetails()
    }
    
    func setupUI() {
        self.view.addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        headerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        headerView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        
        self.view.addSubview(detailsView)
        detailsView.translatesAutoresizingMaskIntoConstraints = false
        detailsView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        detailsView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        detailsView.topAnchor.constraint(equalTo: self.headerView.bottomAnchor, constant: -50).isActive = true
        detailsView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        self.headerView.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.leadingAnchor.constraint(equalTo: self.headerView.leadingAnchor, constant: 25).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: self.headerView.trailingAnchor, constant: 20).isActive = true
        nameLabel.topAnchor.constraint(equalTo: self.headerView.topAnchor, constant: 30).isActive = true
        
        self.view.addSubview(itemImageView)
        itemImageView.topAnchor.constraint(equalTo: self.nameLabel.bottomAnchor, constant: 75).isActive = true
        itemImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        itemImageView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        let size: CGFloat = 200
        itemImageView.heightAnchor.constraint(equalToConstant: size).isActive = true
        itemImageView.widthAnchor.constraint(equalToConstant: size).isActive = true
        itemImageView.cornerRadius = size/2
        
        self.detailsView.addSubview(uidLabel)
        uidLabel.translatesAutoresizingMaskIntoConstraints = false
        uidLabel.leadingAnchor.constraint(equalTo: self.detailsView.leadingAnchor, constant: 25).isActive = true
        uidLabel.trailingAnchor.constraint(equalTo: self.detailsView.trailingAnchor, constant: -25).isActive = true
        uidLabel.topAnchor.constraint(equalTo: self.detailsView.topAnchor, constant: 100).isActive = true
        
        self.detailsView.addSubview(priceLabel)
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.leadingAnchor.constraint(equalTo: self.detailsView.leadingAnchor, constant: 25).isActive = true
        priceLabel.topAnchor.constraint(equalTo: self.uidLabel.bottomAnchor, constant: 20).isActive = true
        
        self.detailsView.addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.leadingAnchor.constraint(equalTo: self.detailsView.leadingAnchor, constant: 25).isActive = true
        dateLabel.topAnchor.constraint(equalTo: self.priceLabel.bottomAnchor, constant: 20).isActive = true
    }
    
    // MARK: - Update UI
    func update(_ item: Item) {
        self.item = item
        headerView.backgroundColor = item.bgColors?.0
        nameLabel.text = item.name?.capitalized
        priceLabel.attributedText = NSMutableAttributedString().bold("Price: ").normal(item.price ?? String.empty)
        dateLabel.attributedText = NSMutableAttributedString().bold("Date: ").normal(item.createdAt?.formattedDate ?? String.empty)
        uidLabel.attributedText = NSMutableAttributedString().bold("UID: ").normal(item.uid ?? String.empty)
        
        if let imageURL = item.imageURL, let itemNumber = self.item?.imageID {
            self.itemImageView.setImage(url: imageURL, itemNumber: itemNumber as NSString)
        }
    }
}

extension ItemDetailsViewController {
    
    // MARK: ItemDetails Display Logic
    
    func displayItemDetails()
    {
        if let item = interactor?.item {
            update(item)
        }
    }
}
