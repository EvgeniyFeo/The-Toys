//
//  TemplateTextField.swift
//  The Toys
//
//  Created by Eugene Feoktistov on 7/20/22.
//

import UIKit

class TemplateTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupTextField()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTextField() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
        self.borderStyle = .none
        self.layer.borderWidth = 0.5
        self.layer.cornerRadius = 5
        self.clearButtonMode = .whileEditing
        self.autocorrectionType = .no
        self.autocapitalizationType = .none
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate(
            [
                self.heightAnchor.constraint(equalToConstant: 30)
            ]
        )
    }
}
