//
//  ShopOnMap.swift
//  The Toys
//
//  Created by Eugene Feoktistov on 7/21/22.
//

class ShopOnMap {
    
    var latitude: Double
    var longitude: Double
    var workingHours: String
    var name: String

    init(latitude: Double, longitude: Double, name: String, workingHours: String) {
        self.workingHours = workingHours
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
    }
}
