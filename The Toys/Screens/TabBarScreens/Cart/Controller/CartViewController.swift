//
//  CartViewController.swift
//  The Toys
//
//  Created by Eugene Feoktistov on 7/20/22.
//

import UIKit

class CartViewController: TemplateViewController {
    
    //    MARK: - Variables -
    
    var cartProducts: [ProductsAddedToCart] = []
    private var addressButonsArray: [TemplateButton] = []
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ProductsInCartTableViewCell.self, forCellReuseIdentifier: ProductsInCartTableViewCell.reuseIdentifier)
        tableView.tableFooterView = UIView()
        
        return tableView
    }()
    
    private lazy var totalPriceLabel: TemplateLabel = {
        let label = TemplateLabel()
        
        label.text = "Итого:"
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        
        return label
    }()
    
    private lazy var totalPrice: TemplateLabel = {
        let label = TemplateLabel()
        
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        
        return label
    }()
    
    private lazy var totalPriceCurrency: TemplateLabel = {
        let label = TemplateLabel()
        
        label.text = "руб."
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        
        return label
    }()
    
    private lazy var deliverySegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl()
        
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.insertSegment(withTitle: "Доставка", at: 0, animated: false)
        segmentedControl.insertSegment(withTitle: "Самовывоз", at: 1, animated: false)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.alpha = 1
        segmentedControl.addTarget(self, action: #selector(segmentedControlChangeValue), for: .valueChanged)
        
        return segmentedControl
    }()
    
    private lazy var paymentMethodLabel: TemplateLabel = {
        let label = TemplateLabel()
        
        label.text = "Способ оплаты:"
        
        return label
    }()
    
    private lazy var paymentMetodSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl()
        
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.insertSegment(withTitle: "Наличными", at: 0, animated: false)
        segmentedControl.insertSegment(withTitle: "Картой", at: 1, animated: false)
        segmentedControl.selectedSegmentIndex = 0
        
        return segmentedControl
    }()
    
    private lazy var phoneNumberTextField: TemplateTextField = {
        let textField = TemplateTextField()
        
        textField.placeholder = "Номер телефона"
        textField.keyboardType = .phonePad
        textField.smartInsertDeleteType = .no
        textField.delegate = self
        
        return textField
    }()
    
    private lazy var deliveryAddressTextField: TemplateTextField = {
        let textField = TemplateTextField()
        
        textField.placeholder = "Адрес доставки"
        textField.autocorrectionType = .no
        
        return textField
    }()
    
    private lazy var deliveryStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addSubview(self.paymentMethodLabel)
        stackView.addSubview(self.paymentMetodSegmentedControl)
        stackView.addSubview(self.deliveryAddressTextField)
        stackView.addSubview(self.phoneNumberTextField)
        stackView.addSubview(self.checkoutDeliveryButton)
        
        return stackView
    }()
    
    private lazy var firstAddressButton: TemplateButton = {
        let button = TemplateButton()
        
        button.setTitle("Проспект Машерова 14, 08:00 - 20:00", for: .normal)
        button.showsTouchWhenHighlighted = true
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(isSelectAddress), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var secondAddressButton: TemplateButton = {
        let button = TemplateButton()
        
        button.setTitle("Интернациональная 36, 09:00 - 21:00", for: .normal)
        button.showsTouchWhenHighlighted = true
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(isSelectAddress), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var thirdAddressButton: TemplateButton = {
        let button = TemplateButton()
        
        button.setTitle("Ваупшасова 15, 10:00 - 22:00", for: .normal)
        button.showsTouchWhenHighlighted = true
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(isSelectAddress), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var pickupStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addSubview(self.firstAddressButton)
        stackView.addSubview(self.secondAddressButton)
        stackView.addSubview(self.thirdAddressButton)
        stackView.addSubview(self.checkoutPickupButton)
        stackView.alpha = 0
        
        return stackView
    }()
    
    private lazy var checkoutDeliveryButton: TemplateButton = {
        let button = TemplateButton()
        
        button.setTitle("Оформить заказ", for: .normal)
        button.addTarget(self, action: #selector(checkoutDeliveryButtonDidTap), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var checkoutPickupButton: TemplateButton = {
        let button = TemplateButton()
        
        button.setTitle("Оформить заказ", for: .normal)
        button.addTarget(self, action: #selector(checkoutPickupButtonDidTap), for: .touchUpInside)
        
        return button
    }()
    
    //    MARK: - ViewController LifeCycle -

    
    override func loadView() {
        super.loadView()
        
        self.addSubviews()
        self.setConstraints()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableView.reloadData()
        self.calculateTotalPrice()
        self.hideKeyboard()
        self.addKeyboardObserver()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.removeKeyboardObserver()
    }
    
    //    MARK: - Set ViewController -

    private func addSubviews() {
        
        self.view.addSubview(self.tableView)
        self.view.addSubview(self.totalPriceLabel)
        self.view.addSubview(self.totalPrice)
        self.view.addSubview(self.totalPriceCurrency)
        self.view.addSubview(self.deliverySegmentedControl)
        self.view.addSubview(self.deliveryStackView)
        self.view.addSubview(self.pickupStackView)
    }
    
    private func setConstraints() {
        
        NSLayoutConstraint.activate(
            [
                self.tableView.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor),
                self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                self.tableView.heightAnchor.constraint(equalToConstant: 200),
                
                self.totalPriceLabel.topAnchor.constraint(equalTo: self.tableView.bottomAnchor, constant: 5),
                self.totalPriceLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
                
                self.totalPrice.centerYAnchor.constraint(equalTo: self.totalPriceLabel.centerYAnchor),
                self.totalPrice.leadingAnchor.constraint(equalTo: self.totalPriceLabel.trailingAnchor, constant: 5),
                
                self.totalPriceCurrency.centerYAnchor.constraint(equalTo: self.totalPrice.centerYAnchor),
                self.totalPriceCurrency.leadingAnchor.constraint(equalTo: self.totalPrice.trailingAnchor, constant: 5),
                
                self.deliverySegmentedControl.topAnchor.constraint(equalTo: self.totalPriceCurrency.bottomAnchor, constant: 5),
                self.deliverySegmentedControl.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                self.deliverySegmentedControl.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                self.deliverySegmentedControl.heightAnchor.constraint(equalToConstant: 30),
                
                self.deliveryStackView.topAnchor.constraint(equalTo: self.deliverySegmentedControl.bottomAnchor, constant: 5),
                self.deliveryStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                self.deliveryStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                self.deliveryStackView.heightAnchor.constraint(equalToConstant: 170),
                
                self.paymentMethodLabel.topAnchor.constraint(equalTo: self.deliveryStackView.topAnchor),
                self.paymentMethodLabel.leadingAnchor.constraint(equalTo: self.deliveryStackView.leadingAnchor, constant: 20),
                
                self.paymentMetodSegmentedControl.topAnchor.constraint(equalTo: self.paymentMethodLabel.bottomAnchor, constant: 5),
                self.paymentMetodSegmentedControl.widthAnchor.constraint(equalTo: self.deliveryStackView.widthAnchor, multiplier: 0.75),
                self.paymentMetodSegmentedControl.heightAnchor.constraint(equalToConstant: 25),
                self.paymentMetodSegmentedControl.centerXAnchor.constraint(equalTo: self.deliveryStackView.centerXAnchor),
                
                self.phoneNumberTextField.topAnchor.constraint(equalTo: self.paymentMetodSegmentedControl.bottomAnchor, constant: 10),
                self.phoneNumberTextField.leadingAnchor.constraint(equalTo: self.deliveryStackView.leadingAnchor, constant: 10),
                self.phoneNumberTextField.trailingAnchor.constraint(equalTo: self.deliveryStackView.trailingAnchor, constant: -10),
                
                self.deliveryAddressTextField.topAnchor.constraint(equalTo: self.phoneNumberTextField.bottomAnchor, constant: 10),
                self.deliveryAddressTextField.leadingAnchor.constraint(equalTo: self.phoneNumberTextField.leadingAnchor),
                self.deliveryAddressTextField.trailingAnchor.constraint(equalTo: self.phoneNumberTextField.trailingAnchor),
                
                self.pickupStackView.topAnchor.constraint(equalTo: self.deliverySegmentedControl.bottomAnchor, constant: 5),
                self.pickupStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                self.pickupStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                self.pickupStackView.heightAnchor.constraint(equalToConstant: 150),
                
                self.firstAddressButton.topAnchor.constraint(equalTo: self.pickupStackView.topAnchor),
                self.firstAddressButton.leadingAnchor.constraint(equalTo: self.pickupStackView.leadingAnchor),
                self.firstAddressButton.trailingAnchor.constraint(equalTo: self.pickupStackView.trailingAnchor),
                
                self.secondAddressButton.topAnchor.constraint(equalTo: self.firstAddressButton.bottomAnchor, constant: 5),
                self.secondAddressButton.leadingAnchor.constraint(equalTo: self.pickupStackView.leadingAnchor),
                self.secondAddressButton.trailingAnchor.constraint(equalTo: self.pickupStackView.trailingAnchor),
                
                self.thirdAddressButton.topAnchor.constraint(equalTo: self.secondAddressButton.bottomAnchor, constant: 5),
                self.thirdAddressButton.leadingAnchor.constraint(equalTo: self.pickupStackView.leadingAnchor),
                self.thirdAddressButton.trailingAnchor.constraint(equalTo: self.pickupStackView.trailingAnchor),
                
                self.checkoutDeliveryButton.bottomAnchor.constraint(equalTo: deliveryStackView.bottomAnchor),
                self.checkoutDeliveryButton.widthAnchor.constraint(equalTo: deliveryStackView.widthAnchor, multiplier: 0.6),
                self.checkoutDeliveryButton.heightAnchor.constraint(equalToConstant: 40),
                self.checkoutDeliveryButton.centerXAnchor.constraint(equalTo: deliveryStackView.centerXAnchor),
                
                self.checkoutPickupButton.bottomAnchor.constraint(equalTo: pickupStackView.bottomAnchor),
                self.checkoutPickupButton.widthAnchor.constraint(equalTo: pickupStackView.widthAnchor, multiplier: 0.6),
                self.checkoutPickupButton.heightAnchor.constraint(equalToConstant: 40),
                self.checkoutPickupButton.centerXAnchor.constraint(equalTo: pickupStackView.centerXAnchor),
            ]
        )
    }
    
    //    MARK: - Actions -

    
    @objc private func isSelectAddress(sender: UIButton) {
        sender.isSelected = true
        sender.backgroundColor = .black
        sender.setTitleColor(.white, for: .normal)
        addressButonsArray = [firstAddressButton, secondAddressButton, thirdAddressButton]
        for button in addressButonsArray {
            if button.isSelected && button !== sender {
                button.isSelected = false
                button.backgroundColor = .white
                button.setTitleColor(.black, for: .normal)
            }
        }
    }
    
    @objc private func checkoutDeliveryButtonDidTap(sender: UIButton) {
        
        guard let phone = self.phoneNumberTextField.text,
              let address = self.deliveryAddressTextField.text
        else { return }
        
        if phone.isEmpty || phone.count < 20 {
            self.showAlert(title: "Ошибка", message: "Укажите номер телефона")
        } else if address.isEmpty {
            self.showAlert(title: "Ошибка", message: "Укажите адрес доставки")
        } else if cartProducts.isEmpty {
            self.showAlert(title: "Ошибка", message: "Корзина пуста")
        }
        
        if !phone.isEmpty && phone.count == 20 && !address.isEmpty && !cartProducts.isEmpty {
            self.showAlert(title: "Спасибо", message: "Заказ оформлен")
            self.cartProducts.removeAll()
            self.tableView.reloadData()
            self.totalPrice.text = "0.0"
            self.phoneNumberTextField.text = ""
            self.deliveryAddressTextField.text = ""
        }
    }
    
    @objc private func checkoutPickupButtonDidTap(sender: UIButton) {
        
        if cartProducts.isEmpty {
            self.showAlert(title: "Ошибка", message: "Корзина пуста")
        }
        
        if !cartProducts.isEmpty {
            self.showAlert(title: "Спасибо", message: "Заказ оформлен")
            self.cartProducts.removeAll()
            self.tableView.reloadData()
            self.totalPrice.text = "0.0"
        }
    }
    
    @objc private func segmentedControlChangeValue(sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        
        case 0:
            self.deliveryStackView.alpha = 1
            self.pickupStackView.alpha = 0
            self.view.endEditing(true)
            
        case 1:
            self.deliveryStackView.alpha = 0
            self.pickupStackView.alpha = 1
            self.view.endEditing(true)
            
        default:
            break
        }
    }
}

//    MARK: - ViewController Extensions -


extension CartViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        self.cartProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductsInCartTableViewCell.reuseIdentifier, for: indexPath) as? ProductsInCartTableViewCell,
              let placeholderImage = UIImage(systemName: "questionmark") else { return UITableViewCell() }
        
        let addedProduct = self.cartProducts[indexPath.row]
        cell.setCell(image: addedProduct.product.image ?? placeholderImage,
                     name: addedProduct.product.name,
                     price: addedProduct.product.price,
                     quantity: addedProduct.quantity)
        cell.delegate = self
        cell.product = addedProduct.product
        
        return cell
    }
}

extension CartViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            self.cartProducts.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        self.calculateTotalPrice()
    }
}

extension CartViewController: ProductInCartCellDelegate {
    
    func addProductToCart(with product: Product?, and quantity: Int) {
        
        guard let product = product else { return }
        
        if cartProducts.filter({ $0.product.name == product.name }).count == 0 {
            let addedProduct = ProductsAddedToCart(product: product, quantity: quantity)
            cartProducts.append(addedProduct)
        } else {
            for (index, item) in cartProducts.enumerated() {
                if item.product.name == product.name {
                    if (item.quantity + quantity) < 10 {
                        cartProducts[index].quantity += quantity
                    } else {
                        cartProducts[index].quantity = 10
                    }
                }
            }
        }
    }
    
    @discardableResult func calculateTotalPrice() -> Double {
        
        var totalPrice: Double = 0
        for item in self.cartProducts {
            totalPrice += item.product.price * Double(item.quantity)
        }
        
        self.totalPrice.text = String(totalPrice)
        return totalPrice
    }
}

extension CartViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let text = textField.text else { return false }
        
        let newString = (text as NSString).replacingCharacters(in: range, with: string)
        textField.text = format(with: "+ XXX (XX) XXX-XX-XX", phone: newString)
        return false
    }
}
