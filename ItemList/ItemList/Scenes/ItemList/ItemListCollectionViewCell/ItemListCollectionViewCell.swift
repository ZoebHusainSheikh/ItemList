//
//  ItemListCollectionViewCell.swift
//  ItemList
//
//  Created by Zoeb on 08/11/21.
//

import UIKit

class ItemListCollectionViewCell: UICollectionViewCell {
    private var item: Item?
    private var colors: (UIColor, UIColor)!
    
    @IBOutlet weak var itemImageView : UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var priceContainerView: UIView!
    @IBOutlet weak var itemImageViewWidthLC: NSLayoutConstraint!
    
    override func updateConstraints() {
        super.updateConstraints()
        let imageSize = UIScreen.main.bounds.width / 4
        itemImageView.cornerRadius = imageSize / 2
        itemImageViewWidthLC.constant = imageSize
    }
}

extension ItemListCollectionViewCell {
    
    func update(_ item: Item) {
        self.item = item
        colors = item.colors ?? (UIColor(hex: "#48D0B0"), UIColor(hex: "#5EDFC5"))
        self.contentView.backgroundColor = colors.0
        itemImageView.backgroundColor = colors.1
        priceContainerView.backgroundColor = colors.1
        nameLabel.text = item.name?.capitalized
        priceLabel.text = item.price
        
        DispatchQueue.global().async {
            if let imageThumbURL = item.imageThumbnailURL, let itemNumber = self.item?.imageThumbID {
                self.itemImageView.setImage(url: imageThumbURL, itemNumber: itemNumber as NSString)
            }
        }
    }
}

private extension ItemListCollectionViewCell {
    func setup() {
        itemImageView.cornerRadius = self.contentView.frame.width / 4
    }
}
