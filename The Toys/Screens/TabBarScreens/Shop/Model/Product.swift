//
//  Product.swift
//  The Toys
//
//  Created by Eugene Feoktistov on 7/20/22.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore

class Product {
    var price: Double
    var imageUrl: String
    var name: String
    var description: String
    var details: String
    var image: UIImage?

    init(image: String = "", price: Double = 0, name: String = "", description: String = "", details: String = "") {
        self.price = price
        self.imageUrl = image
        self.name = name
        self.description = description
        self.details = details
    }

    static func parseProduct(productQuery: QueryDocumentSnapshot) -> Product {
        let product = Product()
        product.price = productQuery.get("price") as? Double ?? 0
        product.name = productQuery.get("name") as? String ?? ""
        product.description = productQuery.get("description") as? String ?? ""
        product.details = productQuery.get("details") as? String ?? ""
        product.imageUrl = productQuery.get("image") as? String ?? ""

        return product
    }
}
