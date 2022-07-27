//
//  CardImageView.swift
//  DiscountCardAppUIKit
//
//  Created by nikita9x on 27.07.2022.
//

import UIKit

class CardImageView: UIImageView {
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.tintColor = .orange
        self.layer.cornerRadius = 12
        self.clipsToBounds = true
        self.contentMode = .scaleAspectFit
        self.backgroundColor = .secondarySystemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
