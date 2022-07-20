//
//  AuthorizationViewController.swift
//  The Toys
//
//  Created by Eugene Feoktistov on 7/20/22.
//

import UIKit
import FirebaseAuth

class AuthorizationViewController: TemplateViewController {
    
    //    MARK: - Variables -
    
    private lazy var headerLabel: TemplateLabel = {
        let label = TemplateLabel()
        
        label.text = "The Toys"
        label.font = UIFont.boldSystemFont(ofSize: 70)
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var userEmailTextField: TemplateTextField = {
        let textField = TemplateTextField()
        
        textField.placeholder = "Email"
        textField.keyboardType = .emailAddress
        textField.delegate = self
        
        return textField
    }()
    
    private lazy var userPasswordTextField: TemplateTextField = {
        let textField = TemplateTextField()
        
        textField.placeholder = "Пароль"
        textField.isSecureTextEntry = true
        textField.delegate = self
        
        return textField
    }()
    
    private lazy var loginButton: TemplateButton = {
        let button = TemplateButton()
        
        button.setTitle("Войти", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(loginButtonDidTap), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var registerButton: TemplateButton = {
        let button = TemplateButton()
        
        button.setTitle("Зарегестрироваться", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(registerButtonDidTap), for: .touchUpInside)
        
        return button
    }()
    
    //    MARK: - ViewContoller LifeCicle -
    
    override func loadView() {
        super.loadView()
        
        self.addSubviews()
        self.setConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.addKeyboardObserver()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.hideKeyboard()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.removeKeyboardObserver()
    }
    
    //    MARK: - Set ViewContoller -
    
    private func addSubviews() {
        
        self.view.addSubview(self.headerLabel)
        self.view.addSubview(self.userEmailTextField)
        self.view.addSubview(self.userPasswordTextField)
        self.view.addSubview(self.loginButton)
        self.view.addSubview(self.registerButton)
    }
    
    private func setConstraints() {
        
        NSLayoutConstraint.activate(
            [
                self.headerLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0),
                self.headerLabel.bottomAnchor.constraint(equalTo: self.userEmailTextField.topAnchor, constant: 0),
                self.headerLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
                self.headerLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
                
                self.userEmailTextField.topAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0),
                self.userEmailTextField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
                self.userEmailTextField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
                
                self.userPasswordTextField.topAnchor.constraint(equalTo: self.userEmailTextField.bottomAnchor, constant: 16),
                self.userPasswordTextField.leadingAnchor.constraint(equalTo: self.userEmailTextField.leadingAnchor),
                self.userPasswordTextField.trailingAnchor.constraint(equalTo: self.userEmailTextField.trailingAnchor),
                
                self.loginButton.topAnchor.constraint(equalTo: self.userPasswordTextField.bottomAnchor, constant: 32),
                self.loginButton.widthAnchor.constraint(equalTo: userPasswordTextField.widthAnchor, multiplier: 0.7),
                self.loginButton.centerXAnchor.constraint(equalTo: userPasswordTextField.centerXAnchor),
                
                self.registerButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 16),
                self.registerButton.widthAnchor.constraint(equalTo: loginButton.widthAnchor, multiplier: 1),
                self.registerButton.centerXAnchor.constraint(equalTo: loginButton.centerXAnchor)
                
            ]
        )
    }
    
//    MARK: - Actions -
    
    @objc private func loginButtonDidTap() {
        
        guard let email = userEmailTextField.text,
              let password = userPasswordTextField.text
        else { return }
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            guard let self = self else { return }
            if let error = error as NSError? {
                self.showAlert(title: "Авторизация", message: error.localizedDescription)
            }
        }
    }
    
    @objc private func registerButtonDidTap() {
        
        guard let email = userEmailTextField.text,
              let password = userPasswordTextField.text
        else { return }
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            guard let self = self else { return }
            if let error = error as NSError? {
                self.showAlert(title: "Регистрация", message: error.localizedDescription)
            }
        }
    }
    
}

//    MARK: - ViewContoller Extensions -

extension AuthorizationViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == self.userEmailTextField {
            self.userPasswordTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}
