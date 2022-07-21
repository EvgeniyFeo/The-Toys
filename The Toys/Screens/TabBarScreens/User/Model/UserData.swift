//
//  UserData.swift
//  The Toys
//
//  Created by Eugene Feoktistov on 7/21/22.
//

import UIKit

class UserData {
    var email: String
    var name: String
    var address: String
    var avatar: UIImage?
    
    init(email: String = "", name: String = "", address: String = "", avatar: UIImage? = nil) {
        self.email = email
        self.name = name
        self.address = address
        self.avatar = avatar
    }
}
