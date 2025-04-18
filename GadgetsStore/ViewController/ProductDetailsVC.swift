//
//  ProductDetailsVC.swift
//  GadgetsStore
//
//  Created by Sai Sunder on 15/04/25.
//

import UIKit
import Kingfisher

class ProductDetailsVC: UIViewController {

    
    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var img_Rating: UIView!
    @IBOutlet weak var lbl_Rating: UILabel!
    @IBOutlet weak var lbl_reviews: UILabel!
    @IBOutlet weak var img_liked: UIImageView!
    @IBOutlet weak var lbl_LikedCount: UILabel!
    @IBOutlet weak var lbl_ItemPrice: UILabel!
    @IBOutlet weak var lbl_Description: UILabel!
    @IBOutlet weak var pageControl : UIPageControl!
    @IBOutlet weak var img_Product : UIImageView!
   
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var img_Comment: UIImageView!
    @IBOutlet weak var lbl_commentCount: UILabel!
    @IBOutlet weak var btn_AddToCart: UIButton!
    @IBOutlet weak var btn_Favorite: UIButton!
    
    var product: Product?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ProductDetails:- \(product)")

        lbl_Description.text = "\(product?.description ?? "")"
        lbl_Title.text = "\(product?.title ?? "")"
        lbl_Rating.text = "\(product?.rating.rate ?? 0.0)"
        lbl_ItemPrice.text = "\(product?.price ?? 0)"
        img_Product.kf.indicatorType = .activity
        img_Product.kf.setImage(
            with: URL(string: product?.image ?? ""),
            options: [
                .transition(.fade(0.3)),
                .cacheOriginalImage
            ]
        )
        
        bottomView.layer.cornerRadius = 20
        bottomView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        bottomView.clipsToBounds = true
        updateFavoriteButton()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func updateFavoriteButton() {
        let isFav = CoreDataManager.shared.isFavorited(product?.id ?? 0)
        let imageName = isFav ? "heart.fill" : "heart"
        btn_Favorite.setImage(UIImage(systemName: imageName), for: .normal)
    }


     @IBAction func addToCartTapped(_ sender: UIButton) {
         
         // Update tab bar badge
           if let tabBarVC = self.tabBarController as? TabBarVC {
               tabBarVC.updateCartBadge()
           }
         
         CoreDataManager.shared.addToCart(product: product!)
         let alert = UIAlertController(title: nil, message: "Added to Cart", preferredStyle: .alert)
         alert.addAction(UIAlertAction(title: "OK", style: .default))
         present(alert, animated: true)
     }

     @IBAction func favoriteTapped(_ sender: UIButton) {
         if CoreDataManager.shared.isFavorited(self.product?.id ?? 0) {
             CoreDataManager.shared.removeFromFavorites(id: product?.id ?? 0)
         } else {
             CoreDataManager.shared.addToFavorites(product: product!)
         }
         updateFavoriteButton()
     }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}
