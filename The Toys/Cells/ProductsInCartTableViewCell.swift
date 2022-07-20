//
//  ProductsInCartTableViewCell.swift
//  The Toys
//
//  Created by Eugene Feoktistov on 7/20/22.
//

import UIKit

protocol ProductInCartCellDelegate: class {
    
    func addProductToCart(with product: Product?, and quantity: Int)
    @discardableResult func calculateTotalPrice() -> Double
}

class ProductsInCartTableViewCell: UITableViewCell {
    
    //    MARK: - Variables -
    
    static let reuseIdentifier: String = "ProductsInCartTableViewCell"
    
    let boldCounterButtonTitleAttribute: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.black,
                                                                          .font: UIFont.systemFont(ofSize: 30, weight: .heavy)]
    
    weak var delegate: ProductInCartCellDelegate?
    var product: Product?
    
    private lazy var counter: Int = 0
    
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
    
    private lazy var productPrice: TemplateLabel = {
        let label = TemplateLabel()
        
        label.font = UIFont.boldSystemFont(ofSize: 17)
        
        return label
    }()
    
    private lazy var productPriceCurrencyLabel: TemplateLabel = {
        let label = TemplateLabel()
        
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.text = "руб."
        
        return label
    }()
    
    private lazy var productCurrentQuantity: TemplateLabel = {
        let label = TemplateLabel()
        
        label.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        label.text = "\(self.counter)"
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var addProductItemButton: UIButton = {
        let button = UIButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setAttributedTitle(NSAttributedString(string: "+", attributes: self.boldCounterButtonTitleAttribute), for: .normal)
        button.addTarget(self, action: #selector(addProductItemButtonDidTap), for: .touchUpInside)
        
        
        return button
    }()
    
    private lazy var removeProductItemButton: UIButton = {
        let button = UIButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setAttributedTitle(NSAttributedString(string: "–", attributes: self.boldCounterButtonTitleAttribute), for: .normal)
        button.addTarget(self, action: #selector(removeProductItemButtonDidTap), for: .touchUpInside)
        
        
        return button
    }()
    
    //    MARK: - TableViewCell LifeCycle -
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.initCell()
        self.setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //    MARK: - Set TableViewCell -
    
    func initCell() {
        
        self.contentView.addSubview(self.productImageView)
        self.contentView.addSubview(self.productName)
        self.contentView.addSubview(self.productPrice)
        self.contentView.addSubview(self.productPriceCurrencyLabel)
        self.contentView.addSubview(self.productCurrentQuantity)
        self.contentView.addSubview(self.addProductItemButton)
        self.contentView.addSubview(self.removeProductItemButton)
        self.selectionStyle = .none
    }
    
    func setCell(image: UIImage, name: String, price: Double, quantity: Int) {
        
        self.productImageView.image = image
        self.productName.text = name
        self.productPrice.text = String(price)
        self.productCurrentQuantity.text = String(quantity)
        
    }
    
    private func setConstraints() {
        
        NSLayoutConstraint.activate(
            [
                self.contentView.heightAnchor.constraint(equalToConstant: 60),
                
                self.productImageView.heightAnchor.constraint(equalTo: self.productImageView.widthAnchor, multiplier: 1.0/1.0),
                self.productImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
                self.productImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5),
                self.productImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
                
                self.productName.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
                self.productName.leadingAnchor.constraint(equalTo: self.productImageView.trailingAnchor, constant: 5),
                
                self.productPrice.topAnchor.constraint(equalTo: self.productName.bottomAnchor, constant: 10),
                self.productPrice.leadingAnchor.constraint(equalTo: self.productName.leadingAnchor),
                
                self.productPriceCurrencyLabel.topAnchor.constraint(equalTo: productPrice.topAnchor),
                self.productPriceCurrencyLabel.leadingAnchor.constraint(equalTo: productPrice.trailingAnchor, constant: 5),
                
                self.addProductItemButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
                self.addProductItemButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                
                self.productCurrentQuantity.widthAnchor.constraint(equalToConstant: 40),
                self.productCurrentQuantity.centerYAnchor.constraint(equalTo: self.addProductItemButton.centerYAnchor),
                self.productCurrentQuantity.trailingAnchor.constraint(equalTo: self.addProductItemButton.leadingAnchor),
                
                self.removeProductItemButton.trailingAnchor.constraint(equalTo: self.productCurrentQuantity.leadingAnchor),
                self.removeProductItemButton.topAnchor.constraint(equalTo: self.addProductItemButton.topAnchor),
            ]
        )
    }
    
    //    MARK: - Actions -
    
    @objc func addProductItemButtonDidTap() {
        
        guard let currentQuantity = Int(self.productCurrentQuantity.text ?? "1") else { return }
        
        if currentQuantity < 10 {
            var newQuantity = currentQuantity
            newQuantity += 1
            self.counter = newQuantity
            self.productCurrentQuantity.text = String(newQuantity)
            delegate?.addProductToCart(with: self.product, and: 1)
            delegate?.calculateTotalPrice()
        }
    }
    
    @objc func removeProductItemButtonDidTap() {
        
        guard let currentQuantity = Int(self.productCurrentQuantity.text ?? "1") else { return }
        
        if currentQuantity > 1 {
            var newQuantity = currentQuantity
            newQuantity -= 1
            self.counter = newQuantity
            self.productCurrentQuantity.text = String(newQuantity)
            delegate?.addProductToCart(with: self.product, and: -1)
            delegate?.calculateTotalPrice()
        }
    }
}
