//
//  ProductsItemCell.swift
//  GadgetsStore
//
//  Created by Sai Sunder on 15/04/25.
//

import UIKit

class ProductsItemCell: UICollectionViewCell {

    @IBOutlet weak var img_productImage : UIImageView!
    @IBOutlet weak var lbl_ProductTitle : UILabel!
    @IBOutlet weak var lbl_ProductPrice : UILabel!
    
    @IBOutlet weak var btn_addToFavourites: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
    }

}
