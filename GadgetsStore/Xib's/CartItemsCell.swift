//
//  CartItemsCell.swift
//  GadgetsStore
//
//  Created by Sai Sunder on 15/04/25.
//

import UIKit

class CartItemsCell: UITableViewCell {

    @IBOutlet weak var img_ProductImg : UIImageView!
    @IBOutlet weak var lbl_ProductName : UILabel!
    @IBOutlet weak var lbl_ProductPrice : UILabel!
    @IBOutlet weak var btn_Addmore : UIButton!
    @IBOutlet weak var btn_Addless : UIButton!
    @IBOutlet weak var btn_ProductCheckList : UIButton!
    @IBOutlet weak var lbl_ProductQuantity: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
