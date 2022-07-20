//
//  ProductTableViewCell.swift
//  The Toys
//
//  Created by Eugene Feoktistov on 7/20/22.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore
import FirebaseUI

class ProductTableViewCell: UITableViewCell {
    
    //    MARK: - Variables -
    
    static let reuseIdentifier: String = "ProductTableViewCell"
    private let placeholderImage: UIImage = UIImage(systemName: "questionmark") ?? UIImage()
    
    var productImage: UIImage {
        self.productImageView.image ?? self.placeholderImage
    }
    
    private lazy var productImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.image = UIImage(systemName: "questionmark")
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 5
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.borderWidth = 1
        
        return imageView
    }()
    
    private lazy var productName: TemplateLabel = {
        let label = TemplateLabel()
        
        label.font = UIFont.boldSystemFont(ofSize: 17)
        
        return label
    }()
    
    private lazy var productDescription: TemplateLabel = {
        let label = TemplateLabel()
        
        label.font = UIFont.systemFont(ofSize: 15)
        
        return label
    }()
    
    private lazy var productPrice: TemplateLabel = {
        let label = TemplateLabel()
        
        label.font = UIFont.boldSystemFont(ofSize: 17)
        
        return label
    }()
    
    private lazy var productPriceLabel: TemplateLabel = {
        let label = TemplateLabel()
        
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.text = "Стоимость:"
        
        return label
    }()
    
    private lazy var productPriceCurrencyLabel: TemplateLabel = {
        let label = TemplateLabel()
        
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.text = "руб."
        
        return label
    }()
    
    //    MARK: - TableViewCell LifeCycle -
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        initCell()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //    MARK: - Set TableViewCell -
    
    private func initCell() {
        
        self.contentView.addSubview(self.productImageView)
        self.contentView.addSubview(self.productName)
        self.contentView.addSubview(self.productDescription)
        self.contentView.addSubview(self.productPrice)
        self.contentView.addSubview(self.productPriceLabel)
        self.contentView.addSubview(self.productPriceCurrencyLabel)
        self.selectionStyle = .none
    }
    
    private func setConstraints() {
        
        NSLayoutConstraint.activate(
            [
                self.contentView.heightAnchor.constraint(equalToConstant: 100),
                
                self.productImageView.heightAnchor.constraint(equalTo: self.productImageView.widthAnchor, multiplier: 1.0/1.0),
                self.productImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
                self.productImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5),
                self.productImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
                
                self.productName.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
                self.productName.leadingAnchor.constraint(equalTo: self.productImageView.trailingAnchor, constant: 10),
                
                self.productDescription.topAnchor.constraint(equalTo: self.productName.bottomAnchor, constant: 10),
                self.productDescription.leadingAnchor.constraint(equalTo: self.productImageView.trailingAnchor, constant: 10),
                
                self.productPriceLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
                self.productPriceLabel.leadingAnchor.constraint(equalTo: self.productImageView.trailingAnchor, constant: 10),
                
                self.productPriceCurrencyLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
                self.productPriceCurrencyLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
                
                self.productPrice.trailingAnchor.constraint(equalTo: self.productPriceCurrencyLabel.leadingAnchor, constant: -5),
                self.productPrice.bottomAnchor.constraint(equalTo: productPriceCurrencyLabel.bottomAnchor)
            ]
        )
    }
    
    private func loadImage(product: Product) {
        
        let storageRef = Storage.storage().reference()
        let reference = storageRef.child(product.imageUrl)
        
        self.productImageView.sd_setImage(with: reference)
    }
    
    func setCell(productQuery: QueryDocumentSnapshot) {
        
        let product = Product.parseProduct(productQuery: productQuery)
        self.productImageView.image = self.placeholderImage
        self.productName.text = product.name
        self.productDescription.text = product.description
        self.productPrice.text = String(product.price)
        
        if !product.imageUrl.isEmpty {
            self.loadImage(product: product)
        }
        
    }
}
