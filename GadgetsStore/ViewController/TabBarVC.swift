//
//  TabBarVC.swift
//  GadgetsStore
//
//  Created by Sai Sunder on 15/04/25.
//

import UIKit

class TabBarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        updateCartBadge()
        tabBar.tintColor = #colorLiteral(red: 0.7921568627, green: 0.8980392157, blue: 0.2862745098, alpha: 1)
        tabBar.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateCartBadge()
    }

    private func setupTabBar() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        // Home
        let homeVC = storyboard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        let homeNav = UINavigationController(rootViewController: homeVC)
        homeNav.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house.fill"), tag: 0)

        // Catalogs
        let catalogsVC = storyboard.instantiateViewController(withIdentifier: "CatalogesVC") as! CatalogesVC
        let catalogsNav = UINavigationController(rootViewController: catalogsVC)
        catalogsNav.tabBarItem = UITabBarItem(title: "Catalogs", image: UIImage(systemName: "square.grid.2x2"), tag: 1)

        // Cart
        let cartVC = storyboard.instantiateViewController(withIdentifier: "CartVC") as! CartVC
        let cartNav = UINavigationController(rootViewController: cartVC)
        cartNav.tabBarItem = UITabBarItem(title: "Cart", image: UIImage(systemName: "cart.fill"), tag: 2)

        // Favourites
        let favouritesVC = storyboard.instantiateViewController(withIdentifier: "FavouritesVC") as! FavouritesVC
        let favouritesNav = UINavigationController(rootViewController: favouritesVC)
        favouritesNav.tabBarItem = UITabBarItem(title: "Favourites", image: UIImage(systemName: "heart.fill"), tag: 3)

        // Profile
        let profileVC = storyboard.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
        let profileNav = UINavigationController(rootViewController: profileVC)
        profileNav.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.circle.fill"), tag: 4)

        // Assign to tab bar
        viewControllers = [homeNav, catalogsNav, cartNav, favouritesNav, profileNav]
    }
    
    func updateCartBadge() {
        let count = CoreDataManager.shared.cartItemCount()
        let cartTabIndex = 2 // Cart Tab Index

        if let items = tabBar.items, items.indices.contains(cartTabIndex) {
            let cartItem = items[cartTabIndex]
            cartItem.badgeValue = count > 0 ? "\(count)" : nil
        }
    }
    
}

