//
//  FlashSaleCell.swift
//  GadgetsStore
//
//  Created by Sai Sunder on 15/04/25.
//

import UIKit
import Kingfisher


class FlashSaleCell: UITableViewCell {
    
    @IBOutlet weak var collectionView : UICollectionView!
    @IBOutlet weak var btn_SeeAll : UIButton!
    @IBOutlet weak var timerLabel : UILabel!
    
    var products: [Product] = []
    var selfVC = HomeVC()
    
    var countdownTimer: Timer?
    var totalTime: TimeInterval = 7200 // 2 hours in seconds (2 * 60 * 60)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "ProductsItemCell", bundle: nil), forCellWithReuseIdentifier: "ProductsItemCell")
        print("productsData:- \(products)")
        startTimer()
        btn_SeeAll.addTarget(self, action: #selector(seeAllBtnTapped(_:)), for: .touchUpInside)
    }
    
    func startTimer() {
        updateTimerLabel() // Set initial time
        countdownTimer = Timer.scheduledTimer(timeInterval: 1.0,
                                              target: self,
                                              selector: #selector(updateTimer),
                                              userInfo: nil,
                                              repeats: true)
    }

    @objc func updateTimer() {
        if totalTime > 0 {
            totalTime -= 1
            updateTimerLabel()
        } else {
            countdownTimer?.invalidate()
            countdownTimer = nil
            timerLabel.text = "Time's up"
        }
    }

    func updateTimerLabel() {
        let hours = Int(totalTime) / 3600
        let minutes = (Int(totalTime) % 3600) / 60
        let seconds = Int(totalTime) % 60

        timerLabel.text = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    @objc func seeAllBtnTapped(_ sender : UIButton) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "ViewAllProductsVC") as! ViewAllProductsVC
        vc.products = self.products
        vc.hidesBottomBarWhenPushed = true
        selfVC.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func fetchProductDetailsApi() {
        NetworkManager.shared.fetchProducts { result in
            switch result {
            case .success(let products):
                print("Fetched \(products.count) products.")
                self.products = products
                self.collectionView.reloadData()
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}

extension FlashSaleCell : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductsItemCell", for: indexPath) as? ProductsItemCell
        else { return UICollectionViewCell() }

        
        if !products.isEmpty {
            let product = products[indexPath.item]
            cell.lbl_ProductPrice.text = "€\(product.price)"
            cell.lbl_ProductTitle.text = product.title
            
            cell.img_productImage.kf.indicatorType = .activity
            cell.img_productImage.kf.setImage(
                with: URL(string: product.image),
                options: [
                    .transition(.fade(0.3)),
                    .cacheOriginalImage
                ]
            )
            
            cell.btn_addToFavourites.tag = indexPath.item
            cell.btn_addToFavourites.setImage(
                CoreDataManager.shared.isFavorited(product.id) ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart"),
                for: .normal
            )
            cell.btn_addToFavourites.addTarget(self, action: #selector(toggleFavorite(_:)), for: .touchUpInside)

        }
        
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = 165 // matches roughly what’s shown
        let height: CGFloat = collectionView.bounds.height - 10 // some bottom padding
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = (storyBoard.instantiateViewController(identifier: "ProductDetailsVC") as! ProductDetailsVC)
        vc.product = products[indexPath.item]
        vc.hidesBottomBarWhenPushed = true
        selfVC.navigationController?.pushViewController(vc, animated: true)
    }
    
}
