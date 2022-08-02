//
//  CardCollectionViewCell.swift
//  DiscountCardAppUIKit
//
//  Created by nikita9x on 09.07.2022.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "CardCollectionViewCell"
    
    var textLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 13)
        return label
    }()
    var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        addSubview(textLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = CGRect(x:0, y: 0 , width: frame.size.width, height: frame.size.width / 1.586)
        imageView.layer.cornerRadius = frame.size.width * 0.06
        
        textLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.textLabel.text = nil
        self.imageView.image = nil
    }
    
    func configure(with viewModel: Card) {
        self.textLabel.text = viewModel.name
        self.imageView.image = viewModel.loadMainImage()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) not implemented")
    }
    
    override class func awakeFromNib() {
        super.awakeFromNib()
        fatalError("Interface builder not implemented")
    }
}


