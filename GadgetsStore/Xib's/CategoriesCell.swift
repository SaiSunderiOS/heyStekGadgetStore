//
//  CategoriesCell.swift
//  GadgetsStore
//
//  Created by Sai Sunder on 15/04/25.
//

import UIKit

class CategoriesCell: UITableViewCell {

    @IBOutlet weak var collectionView : UICollectionView!
    
    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var btn_SeeAll: UIButton!
    
    var categories: [String] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        let nib = UINib(nibName: "CategoriesItemsCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "CategoriesItemsCell")
        
        bgView.layer.cornerRadius = 15
        bgView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        bgView.clipsToBounds = true
        
    }
}
extension CategoriesCell : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoriesItemsCell", for: indexPath) as? CategoriesItemsCell else {
            return UICollectionViewCell()
        }
        
        cell.lbl_Categories.text = categories[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: collectionView.bounds.height)
    }

}
