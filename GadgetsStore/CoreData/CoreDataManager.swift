//
//  CoreDataManager.swift
//  GadgetsStore
//
//  Created by Sai Sunder on 18/04/25.
//

// CoreDataManager.swift

import UIKit
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    // MARK: - Cart Management

    func addToCart(product: Product) {
        if fetchCartProduct(by: product.id) != nil {
            updateQuantity(for: product.id, increment: true)
            return
        }

        let item = CartProduct(context: context)
        item.id = Int32(product.id)
        item.title = product.title
        item.image = product.image
        item.price = product.price
        item.quantity = 1
        save()
    }

    func fetchCartItems() -> [CartProduct] {
        let request: NSFetchRequest<CartProduct> = CartProduct.fetchRequest()
        return (try? context.fetch(request)) ?? []
    }

    func fetchCartProduct(by id: Int) -> CartProduct? {
        return fetchCartItems().first { $0.id == id }
    }

    func updateQuantity(for id: Int, increment: Bool) {
        if let product = fetchCartProduct(by: id) {
            product.quantity += increment ? 1 : -1
            if product.quantity <= 0 {
                context.delete(product)
            }
            save()
        }
    }
    
    func cartItemCount() -> Int {
        return fetchCartItems().reduce(0) { $0 + Int($1.quantity) }
    }


    func removeCartItem(id: Int) {
        if let product = fetchCartProduct(by: id) {
            context.delete(product)
            save()
        }
    }

    // MARK: - Favorites Management

    func addToFavorites(product: Product) {
        if isFavorited(product.id) { return }

        let item = FavoriteProduct(context: context)
        item.id = Int32(product.id)
        item.title = product.title
        item.image = product.image
        item.price = product.price
        item.productDescription = product.description
        save()
    }

    func removeFromFavorites(id: Int) {
        if let fav = fetchFavorites().first(where: { $0.id == Int32(id) }) {
            context.delete(fav)
            save()
        }
    }

    func isFavorited(_ id: Int) -> Bool {
        return fetchFavorites().contains { $0.id == Int32(id) }
    }

    func fetchFavorites() -> [FavoriteProduct] {
        let request: NSFetchRequest<FavoriteProduct> = FavoriteProduct.fetchRequest()
        return (try? context.fetch(request)) ?? []
    }

    // MARK: - Save

    func save() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("CoreData Save Error: \(error.localizedDescription)")
            }
        }
    }
}
