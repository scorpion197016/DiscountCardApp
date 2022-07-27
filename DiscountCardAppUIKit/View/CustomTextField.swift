//
//  CustomTextFiedl.swift
//  DiscountCardAppUIKit
//
//  Created by nikita9x on 27.07.2022.
//

import UIKit

class CustomTextField: UITextField {
    init(placeholder: String) {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        backgroundColor = .secondarySystemBackground
        layer.borderWidth = 1
        layer.cornerRadius = 6
        layer.masksToBounds = true
        layer.borderColor = UIColor.systemGray.cgColor
        self.placeholder = placeholder
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        leftView = paddingView
        leftViewMode = .always
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
