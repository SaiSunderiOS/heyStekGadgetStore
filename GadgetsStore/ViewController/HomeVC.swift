//
//  HomeVC.swift
//  GadgetsStore
//
//  Created by Sai Sunder on 15/04/25.
//

import UIKit

class HomeVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var topBgView: UIView!
    
    private var products: [Product] = []
    private var categories: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "CategoriesCell", bundle: nil), forCellReuseIdentifier: "CategoriesCell")
        tableView.register(UINib(nibName: "FlashSaleCell", bundle: nil), forCellReuseIdentifier: "FlashSaleCell")
        
        topBgView.layer.cornerRadius = 15
        topBgView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        topBgView.clipsToBounds = true
        fetchProductDetailsApi()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//       Fetch Cart Items Count
        if let tabBarVC = self.tabBarController as? TabBarVC {
            tabBarVC.updateCartBadge()
        }
    }
    
    private func fetchProductDetailsApi() {
        NetworkManager.shared.fetchProducts { result in
            switch result {
            case .success(let products):
                self.products = products
                self.categories = Array(Set(products.map { $0.category })).sorted()
                
                DispatchQueue.main.async {
                    print("Categories count: \(self.categories.count)")
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
}

extension HomeVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CategoriesCell") as? CategoriesCell else { return UITableViewCell() }
            cell.categories = self.categories
            cell.collectionView.reloadData()
            return cell
            
        } else if indexPath.row == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "FlashSaleCell") as? FlashSaleCell else { return UITableViewCell() }
            cell.products = self.products
            cell.collectionView.reloadData()
            cell.selfVC = self
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let totalHeight = tableView.bounds.height

        if indexPath.row == 0 {
            return totalHeight * 0.35 // 35%
        } else if indexPath.row == 1 {
            return totalHeight * 0.65 // 65%
        } else {
            return UITableView.automaticDimension
        }
    }
}
