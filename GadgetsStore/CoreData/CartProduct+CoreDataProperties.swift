//
//  CartProduct+CoreDataProperties.swift
//  GadgetsStore
//
//  Created by Sai Sunder on 18/04/25.
//
//

import Foundation
import CoreData


extension CartProduct {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CartProduct> {
        return NSFetchRequest<CartProduct>(entityName: "CartProduct")
    }

    @NSManaged public var id: Int32
    @NSManaged public var title: String?
    @NSManaged public var image: String?
    @NSManaged public var quantity: Int16
    @NSManaged public var price: Double

}

extension CartProduct : Identifiable {

}
