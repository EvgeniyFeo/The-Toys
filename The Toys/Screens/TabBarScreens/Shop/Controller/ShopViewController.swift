//
//  ShopViewController.swift
//  The Toys
//
//  Created by Eugene Feoktistov on 7/20/22.
//

import UIKit
import FirebaseFirestore

class ShopViewController: UIViewController {
    
    //    MARK: - Variables -
    
    private var products: [QueryDocumentSnapshot] = [] {
        didSet {
            self.filteredProducts = self.products
        }
    }
    
    private lazy var filteredProducts: [QueryDocumentSnapshot] = self.products
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "Поиск"
        searchBar.delegate = self
        
        return searchBar
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ProductTableViewCell.self, forCellReuseIdentifier: ProductTableViewCell.reuseIdentifier)
        tableView.keyboardDismissMode = .onDrag
        tableView.tableFooterView = UIView()
        
        return tableView
    }()
    
    //    MARK: - ViewController LifeCycle -
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.navigationItem.title = "Каталог"
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        self.loadProductData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        self.addSubviews()
        self.setConstraints()
    }
    
    //    MARK: - Set ViewController -
    
    private func addSubviews() {
        
        self.view.addSubview(self.searchBar)
        self.view.addSubview(self.tableView)
    }
    
    private func loadProductData() {
        
        let db = Firestore.firestore()
        db.collection("products").getDocuments { [weak self] (snapshot, error) in
            guard let self = self else { return }
            if let error = error {
                Swift.debugPrint(error.localizedDescription)
            } else if let snapshot = snapshot {
                self.products = snapshot.documents
            }
            self.tableView.reloadData()
        }
    }
    
    private func setConstraints() {
        
        NSLayoutConstraint.activate(
            [
                self.searchBar.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor),
                self.searchBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                self.searchBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                
                self.tableView.topAnchor.constraint(equalTo: self.searchBar.bottomAnchor),
                self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            ]
        )
    }
}

//    MARK: - ViewController Extensions -

extension ShopViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.filteredProducts = searchText.isEmpty ? products : products.filter { ($0.get("name") as? String ?? "").lowercased().contains(searchText.lowercased()) || ($0.get("description") as? String ?? "").lowercased().contains(searchText.lowercased()) }
        
        self.tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.endEditing(true)
    }
}

extension ShopViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        filteredProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductTableViewCell.reuseIdentifier, for: indexPath) as? ProductTableViewCell else { return UITableViewCell() }
        
        let product = self.filteredProducts[indexPath.row]
        cell.setCell(productQuery: product)
        
        return cell
    }
}

extension ShopViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = ProductDetailViewController()
        let product = Product.parseProduct(productQuery: filteredProducts[indexPath.row])
        if let cell = tableView.cellForRow(at: indexPath) as? ProductTableViewCell {
            product.image = cell.productImage
        }
        vc.loadData(product: product)
        navigationController?.pushViewController(vc, animated: true)
    }
}
