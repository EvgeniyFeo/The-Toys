//
//  FillUserDataViewController.swift
//  The Toys
//
//  Created by Eugene Feoktistov on 7/21/22.
//

import UIKit
import FirebaseAuth

class FillUserDataViewController: TemplateViewController {
    
    //    MARK: - Variables -

    private lazy var userFillName: TemplateTextField = {
        let textField = TemplateTextField()
        
        textField.placeholder = "Фамилия Имя"
        
        return textField
    }()
    
    private lazy var saveDataButton: TemplateButton = {
        let bottun = TemplateButton()
        
        bottun.setTitle("Сохранить", for: .normal)
        bottun.addTarget(self, action: #selector(saveUserData), for: .touchUpInside)
        
        return bottun
    }()
    
    private lazy var goBackButton: TemplateButton = {
        let bottun = TemplateButton()
        
        bottun.setTitle("Отменить", for: .normal)
        bottun.addTarget(self, action: #selector(closeViewController), for: .touchUpInside)
        
        return bottun
    }()

    //    MARK: - ViewContoller LifeCicle -
    
    override func loadView() {
        super.loadView()
        
        self.addSubviews()
        self.setConstraits()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        self.hideKeyboard()
    }
    
    //    MARK: - Set ViewContoller -
    
    private func addSubviews() {
        self.view.addSubview(userFillName)
        self.view.addSubview(saveDataButton)
        self.view.addSubview(goBackButton)
    }
    
    private func setConstraits() {
        
        NSLayoutConstraint.activate(
            [
                self.userFillName.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor, constant: 20),
                self.userFillName.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 25),
                self.userFillName.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -25),
                
                self.saveDataButton.bottomAnchor.constraint(equalTo: self.goBackButton.topAnchor, constant: -15),
                self.saveDataButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.5),
                self.saveDataButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                
                self.goBackButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -30),
                self.goBackButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.5),
                self.goBackButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
            ]
        )
    }
    
    //    MARK: - Actions -
    
    @objc private func saveUserData() {
        
        guard let name = userFillName.text,
              let user = Auth.auth().currentUser
        else { return }
        
        if name.isEmpty {
            showAlert(title: "Ошибка", message: "Внесите данные")
        } else {
            let changeData = user.createProfileChangeRequest()
            changeData.displayName = name
            changeData.commitChanges { error in
                if let error = error {
                    print(error)
                }
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @objc private func closeViewController() {
        
        self.navigationController?.popViewController(animated: true)
    }
}
