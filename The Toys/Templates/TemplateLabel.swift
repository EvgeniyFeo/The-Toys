//
//  TemplateLabel.swift
//  The Toys
//
//  Created by Eugene Feoktistov on 7/20/22.
//

import UIKit

class TemplateLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
