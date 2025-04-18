//
//  FavouritesVC.swift
//  GadgetsStore
//
//  Created by Sai Sunder on 15/04/25.
//

import UIKit

class FavouritesVC: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var favoriteItems: [FavoriteProduct] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "ProductsItemCell", bundle: nil), forCellWithReuseIdentifier: "ProductsItemCell")

        loadFavorites()
    }

    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
         loadFavorites()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
     }

     func loadFavorites() {
         favoriteItems = CoreDataManager.shared.fetchFavorites()
         collectionView.reloadData()
     }
 }

 extension FavouritesVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         return favoriteItems.count
     }

     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductsItemCell", for: indexPath) as? ProductsItemCell else {
             return UICollectionViewCell()
         }

         let item = favoriteItems[indexPath.item]
         cell.lbl_ProductTitle.text = item.title
         cell.lbl_ProductPrice.text = "€\(item.price)"
         cell.img_productImage.kf.setImage(with: URL(string: item.image ?? ""), options: [.transition(.fade(0.3)), .cacheOriginalImage])

         cell.btn_addToFavourites.setImage(UIImage(systemName: "heart.fill"), for: .normal)
         cell.btn_addToFavourites.tag = indexPath.item
         cell.btn_addToFavourites.addTarget(self, action: #selector(removeFromFavorites(_:)), for: .touchUpInside)

         return cell
     }

     @objc func removeFromFavorites(_ sender: UIButton) {
         let product = favoriteItems[sender.tag]
         CoreDataManager.shared.removeFromFavorites(id: Int(product.id))
         loadFavorites()
     }


     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         let storyboard = UIStoryboard(name: "Main", bundle: nil)
         let detailVC = storyboard.instantiateViewController(withIdentifier: "ProductDetailsVC") as! ProductDetailsVC

         // Manually construct Product object since FavoriteProduct is Core Data
         let fav = favoriteItems[indexPath.item]
         let product = Product(id: Int(fav.id), title: fav.title ?? "", price: fav.price, description: fav.productDescription ?? "", category: "", image: fav.image ?? "", rating: Rating(rate: 0, count: 0))

         detailVC.product = product
         detailVC.hidesBottomBarWhenPushed = true
         self.navigationController?.pushViewController(detailVC, animated: true)
     }
     
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
         let numberOfItemsPerRow: CGFloat = 2
         let spacing: CGFloat = 10 // space between cells
         let totalSpacing = (numberOfItemsPerRow - 1) * spacing
         let insets: CGFloat = 10 // optional: adjust if you set section insets
         
         let availableWidth = collectionView.bounds.width - totalSpacing - insets
         let itemWidth = floor(availableWidth / numberOfItemsPerRow)
         
         return CGSize(width: itemWidth, height: itemWidth * 2) // or adjust height ratio
     }
 }
    

