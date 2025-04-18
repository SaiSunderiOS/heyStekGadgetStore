//
//  CartVC.swift
//  GadgetsStore
//
//  Created by Sai Sunder on 15/04/25.
//

import UIKit

class CartVC: UIViewController {

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var tableView : UITableView!
    
    var cartItems: [CartProduct] = []
    var selectedItems: Set<Int32> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        topView.layer.cornerRadius = 15
        topView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        topView.clipsToBounds = true
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "CartItemsCell", bundle: nil), forCellReuseIdentifier: "CartItemsCell")

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupHeaderView()
        fetchCartItems()
        if let tabBarVC = self.tabBarController as? TabBarVC {
            tabBarVC.updateCartBadge()
        }
    }

    private func setupHeaderView() {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 50))
        headerView.backgroundColor = .systemGray6

        let checkbox = UIButton(type: .system)
        checkbox.setImage(UIImage(systemName: "circle"), for: .normal)
        checkbox.tintColor = .black
        checkbox.frame = CGRect(x: 15, y: 10, width: 30, height: 30)
        checkbox.addTarget(self, action: #selector(selectAllTapped), for: .touchUpInside)
        checkbox.tag = 99
        headerView.addSubview(checkbox)

        let label = UILabel(frame: CGRect(x: 55, y: 10, width: 150, height: 30))
        label.text = "Select All"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.tag = 100
        headerView.addSubview(label)

        tableView.tableHeaderView = headerView
    }

    @objc func selectAllTapped(_ sender: UIButton) {
        guard let headerView = self.tableView.tableHeaderView else { return }
        let label = headerView.viewWithTag(100) as? UILabel
        let isSelectingAll = selectedItems.count != cartItems.count

        if isSelectingAll {
            selectedItems = Set(cartItems.map { $0.id })
            sender.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
            label?.text = "Deselect All"
        } else {
            selectedItems.removeAll()
            sender.setImage(UIImage(systemName: "circle"), for: .normal)
            label?.text = "Select All"
        }

        tableView.reloadData()
    }

     private func fetchCartItems() {
         cartItems = CoreDataManager.shared.fetchCartItems()
         tableView.reloadData()
     }

     func updateItemQuantity(id: Int32, increment: Bool) {
         CoreDataManager.shared.updateQuantity(for: Int(id), increment: increment)
         fetchCartItems()
         
         if let tabBarVC = self.tabBarController as? TabBarVC {
             tabBarVC.updateCartBadge()
         }
     }

     func removeItem(id: Int32) {
         CoreDataManager.shared.removeCartItem(id: Int(id))
         fetchCartItems()
         
         if let tabBarVC = self.tabBarController as? TabBarVC {
             tabBarVC.updateCartBadge()
         }
     }

     @IBAction func checkoutTapped(_ sender: UIButton) {
         let alert = UIAlertController(title: "Thank You", message: "Your order has been placed.", preferredStyle: .alert)
         alert.addAction(UIAlertAction(title: "OK", style: .default))
         present(alert, animated: true)
     }

}
extension CartVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CartItemsCell", for: indexPath) as? CartItemsCell else {
            return UITableViewCell()
        }

        let item = cartItems[indexPath.row]
        cell.lbl_ProductName.text = item.title
        cell.lbl_ProductPrice.text = "€\(item.price * Double(item.quantity))"
        cell.img_ProductImg.loadImage(urlString: item.image ?? "")
        UIView.transition(with: cell.lbl_ProductQuantity, duration: 0.2, options: .transitionFlipFromTop) {
            cell.lbl_ProductQuantity.text = "\(item.quantity)"
            cell.lbl_ProductPrice.text = "€\(item.price * Double(item.quantity))"
        }


        cell.btn_Addmore.tag = indexPath.row
        cell.btn_Addless.tag = indexPath.row
        cell.btn_ProductCheckList.tag = indexPath.row

        cell.btn_Addmore.addTarget(self, action: #selector(addMoreTapped(_:)), for: .touchUpInside)
        cell.btn_Addless.addTarget(self, action: #selector(addLessTapped(_:)), for: .touchUpInside)
        cell.btn_ProductCheckList.addTarget(self, action: #selector(toggleCheck(_:)), for: .touchUpInside)

        let isSelected = selectedItems.contains(item.id)
        let checkImage = isSelected ? UIImage(systemName: "checkmark.circle.fill") : UIImage(systemName: "circle")
        cell.btn_ProductCheckList.setImage(checkImage, for: .normal)

        return cell
    }

    @objc func addMoreTapped(_ sender: UIButton) {
        let item = cartItems[sender.tag]
        updateItemQuantity(id: item.id, increment: true)
    }

    @objc func addLessTapped(_ sender: UIButton) {
        let item = cartItems[sender.tag]
        if item.quantity > 1 {
            updateItemQuantity(id: item.id, increment: false)
        } else {
            removeItem(id: item.id)
        }
    }

    @objc func toggleCheck(_ sender: UIButton) {
        let item = cartItems[sender.tag]
        if selectedItems.contains(item.id) {
            selectedItems.remove(item.id)
        } else {
            selectedItems.insert(item.id)
        }
        tableView.reloadRows(at: [IndexPath(row: sender.tag, section: 0)], with: .none)
    }
}
