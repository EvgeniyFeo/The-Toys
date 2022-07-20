//
//  TabBarViewController.swift
//  The Toys
//
//  Created by Eugene Feoktistov on 7/20/22.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTabBar()
        customizeTabBar()
    }
    
    private func setupTabBar() {
        let shopController = ShopViewController()
        shopController.tabBarItem = UITabBarItem(title: "Магазин",
                                                 image: UIImage(systemName: "house"),
                                                 selectedImage: UIImage(systemName: "house.fill"))

        let cartController = CartViewController()
        cartController.tabBarItem = UITabBarItem(title: "Корзина",
                                                 image: UIImage(systemName: "cart"),
                                                 selectedImage: UIImage(systemName: "cart.fill"))

        let mapController = MapViewController()
        mapController.tabBarItem = UITabBarItem(title: "Карта",
                                                image: UIImage(systemName: "map"),
                                                selectedImage: UIImage(systemName: "map.fill"))

        let profileController = UserViewController()
        profileController.tabBarItem = UITabBarItem(title: "Профиль",
                                                    image: UIImage(systemName: "person"),
                                                    selectedImage: UIImage(systemName: "person.fill"))

        self.setViewControllers([
            UINavigationController(rootViewController: shopController),
            UINavigationController(rootViewController: cartController),
            mapController,
            UINavigationController(rootViewController: profileController)
        ], animated: true)
    }
    
    private func customizeTabBar() {
        self.tabBar.isTranslucent = false
        self.tabBar.tintColor = .white
        self.tabBar.barTintColor = .black
    }
}
