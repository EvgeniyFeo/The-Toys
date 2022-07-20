//
//  ProductDetailViewController.swift
//  The Toys
//
//  Created by Eugene Feoktistov on 7/20/22.
//

import UIKit

class ProductDetailViewController: UIViewController {
    
    //    MARK: - Variables -
    
    private var product: Product?
    private var counter = 1
    
    private let boldCounterButtonTitleAttribute: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.black,
                                                                                  .font: UIFont.systemFont(ofSize: 30, weight: .heavy)]
    
    private lazy var productImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.image = UIImage(systemName: "questionmark")
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.borderWidth = 1
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private lazy var productName: TemplateLabel = {
        let label = TemplateLabel()
        
        label.font = UIFont.boldSystemFont(ofSize: 20)
        
        return label
    }()
    
    private lazy var productDescription: TemplateLabel = {
        let label = TemplateLabel()
        
        label.font = UIFont.systemFont(ofSize: 15)
        
        return label
    }()
    
    private lazy var productPriceLabel: TemplateLabel = {
        let label = TemplateLabel()
        
        label.font = UIFont.systemFont(ofSize: 15)
        label.text = "Стоимость:"
        
        return label
    }()
    
    private lazy var productPrice: TemplateLabel = {
        let label = TemplateLabel()
        
        label.font = UIFont.systemFont(ofSize: 17, weight: .heavy)
        
        return label
    }()
    
    private lazy var productPriceCurrencyLabel: TemplateLabel = {
        let label = TemplateLabel()
        
        label.font = UIFont.systemFont(ofSize: 17, weight: .heavy)
        label.text = "руб."
        
        return label
    }()
    
    private lazy var productDetailsLabel: TemplateLabel = {
        let label = TemplateLabel()
        
        label.font = UIFont.systemFont(ofSize: 15)
        label.text = "Описание:"
        
        return label
    }()
    
    private lazy var productDetails: UITextView = {
        let textView = UITextView()
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.backgroundColor = .clear
        textView.isScrollEnabled = false
        textView.showsVerticalScrollIndicator = false
        textView.isEditable = false
        textView.isSelectable = false
        
        return textView
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
    
    private lazy var productCurrentQuantity: TemplateLabel = {
        let label = TemplateLabel()
        
        label.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        label.text = "\(self.counter)"
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var addToCartButton: TemplateButton = {
        let button = TemplateButton()
        
        button.setTitle("Добавить в корзину", for: .normal)
        button.setImage(UIImage(systemName: "cart.badge.plus"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(addToCartButtonDidTap), for: .touchUpInside)
        
        return button
    }()
    
    //    MARK: - ViewController LifeCycle -
    
    override func loadView() {
        super.loadView()
        
        self.addSubviews()
        self.setConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
    }
    
    //    MARK: - Set ViewController -
    
    private func addSubviews() {
        
        self.view.addSubview(self.productImageView)
        self.view.addSubview(self.productName)
        self.view.addSubview(self.productPrice)
        self.view.addSubview(self.productPriceLabel)
        self.view.addSubview(self.productPriceCurrencyLabel)
        self.view.addSubview(self.productDescription)
        self.view.addSubview(self.productDetailsLabel)
        self.view.addSubview(self.productDetails)
        self.view.addSubview(self.removeProductItemButton)
        self.view.addSubview(self.addProductItemButton)
        self.view.addSubview(self.productCurrentQuantity)
        self.view.addSubview(self.addToCartButton)
    }
    
    func loadData(product: Product) {
        
        self.product = product
        self.productImageView.image = product.image
        self.productPrice.text = String(product.price)
        self.productName.text = product.name
        self.productDescription.text = product.description
        self.productDetails.text = product.details
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate(
            [
                self.productImageView.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor),
                self.productImageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                self.productImageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                self.productImageView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.35),
                
                self.productName.topAnchor.constraint(equalTo: self.productImageView.bottomAnchor, constant: 10),
                self.productName.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 8),
                
                self.productDescription.topAnchor.constraint(equalTo: self.productName.bottomAnchor, constant: 10),
                self.productDescription.leadingAnchor.constraint(equalTo: self.productName.leadingAnchor),
                
                self.productPriceLabel.topAnchor.constraint(equalTo: self.productDescription.bottomAnchor, constant: 20),
                self.productPriceLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 8),
                
                self.productPrice.topAnchor.constraint(equalTo: self.productPriceLabel.topAnchor),
                self.productPrice.leadingAnchor.constraint(equalTo: self.productPriceLabel.trailingAnchor, constant: 5),
                
                self.productPriceCurrencyLabel.topAnchor.constraint(equalTo: self.productPriceLabel.topAnchor),
                self.productPriceCurrencyLabel.leadingAnchor.constraint(equalTo: self.productPrice.trailingAnchor, constant: 5),
                
                self.addProductItemButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -8),
                self.addProductItemButton.centerYAnchor.constraint(equalTo: self.productPriceLabel.centerYAnchor),
                
                self.productCurrentQuantity.widthAnchor.constraint(equalToConstant: 40),
                self.productCurrentQuantity.centerYAnchor.constraint(equalTo: self.addProductItemButton.centerYAnchor),
                self.productCurrentQuantity.trailingAnchor.constraint(equalTo: self.addProductItemButton.leadingAnchor),
                
                self.removeProductItemButton.trailingAnchor.constraint(equalTo: self.productCurrentQuantity.leadingAnchor),
                self.removeProductItemButton.topAnchor.constraint(equalTo: self.addProductItemButton.topAnchor),
                
                self.addToCartButton.topAnchor.constraint(equalTo: self.addProductItemButton.bottomAnchor, constant: 10),
                self.addToCartButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 8),
                self.addToCartButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -8),
                
                self.productDetailsLabel.topAnchor.constraint(equalTo: self.addToCartButton.bottomAnchor, constant: 10),
                self.productDetailsLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 8),
                
                self.productDetails.topAnchor.constraint(equalTo: self.productDetailsLabel.bottomAnchor, constant: 5),
                self.productDetails.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
                self.productDetails.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 15),
                self.productDetails.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -15)
            ]
        )
    }
    
    //    MARK: - Actions -
    
    @objc func addToCartButtonDidTap() {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func addProductItemButtonDidTap() {
        
        guard let currentQuantity = Int(self.productCurrentQuantity.text ?? "1") else { return }
        
        if currentQuantity < 10 {
            var newQuantity = currentQuantity
            newQuantity += 1
            self.counter = newQuantity
            self.productCurrentQuantity.text = String(newQuantity)
        }
    }
    
    @objc func removeProductItemButtonDidTap() {
        
        guard let currentQuantity = Int(self.productCurrentQuantity.text ?? "1") else { return }
        
        if currentQuantity > 1 {
            var newQuantity = currentQuantity
            newQuantity -= 1
            self.counter = newQuantity
            self.productCurrentQuantity.text = String(newQuantity)
        }
    }
}

