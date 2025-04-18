//
//  ViewAllProductsVC.swift
//  GadgetsStore
//
//  Created by Sai Sunder on 15/04/25.
//

import UIKit

class ViewAllProductsVC: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var products: [Product] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "ProductsItemCell", bundle: nil), forCellWithReuseIdentifier: "ProductsItemCell")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: false)
    }
    
    
}
extension ViewAllProductsVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductsItemCell", for: indexPath) as? ProductsItemCell else{ return UICollectionViewCell() }
        
        if !products.isEmpty {
            let product = products[indexPath.item]
            cell.lbl_ProductPrice.text = "\(product.price)"
            cell.lbl_ProductTitle.text = product.title
            
            cell.img_productImage.kf.indicatorType = .activity
            cell.img_productImage.kf.setImage(
                with: URL(string: product.image),
                options: [
                    .transition(.fade(0.3)),
                    .cacheOriginalImage
                ]
            )
        }
        
        cell.btn_addToFavourites.setImage(
            CoreDataManager.shared.isFavorited(products[indexPath.item].id) ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart"),
            for: .normal
        )
        cell.btn_addToFavourites.tag = indexPath.item
        cell.btn_addToFavourites.addTarget(self, action: #selector(toggleFavorite(_:)), for: .touchUpInside)
        
        return cell
        
    }
    
    @objc func toggleFavorite(_ sender: UIButton) {
        let product = products[sender.tag]
        if CoreDataManager.shared.isFavorited(product.id) {
            CoreDataManager.shared.removeFromFavorites(id: product.id)
        } else {
            CoreDataManager.shared.addToFavorites(product: product)
        }
        collectionView.reloadItems(at: [IndexPath(item: sender.tag, section: 0)])
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailVC = storyboard.instantiateViewController(withIdentifier: "ProductDetailsVC") as! ProductDetailsVC
        detailVC.product = products[indexPath.item]
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
