//
//  FavoriteProduct+CoreDataProperties.swift
//  GadgetsStore
//
//  Created by Sai Sunder on 18/04/25.
//
//

import Foundation
import CoreData


extension FavoriteProduct {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteProduct> {
        return NSFetchRequest<FavoriteProduct>(entityName: "FavoriteProduct")
    }

    @NSManaged public var id: Int32
    @NSManaged public var image: String?
    @NSManaged public var price: Double
    @NSManaged public var title: String?
    @NSManaged public var productDescription: String?

}

extension FavoriteProduct : Identifiable {

}
