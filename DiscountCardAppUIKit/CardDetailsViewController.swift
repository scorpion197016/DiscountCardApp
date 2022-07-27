//
//  CardDetailsViewController.swift
//  DiscountCardAppUIKit
//
//  Created by nikita9x on 24.07.2022.
//

import Foundation
import UIKit
import SnapKit

class CardDetailsViewController: UIViewController {
    var card: Card
    
    var barcodeImage: UIImageView = {
        var image = UIImage()
        var imageView = UIImageView(image: image)
        imageView.backgroundColor = .red
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    private var barcodeNumberLabel: UILabel = {
        var label = UILabel()
        label.numberOfLines = 1
        label.font = label.font.withSize(25)
        return label
    }()
    
    private var cardImage: UIImageView = {
        return CardImageView()
    }()
    
    private var backgroundView1: UIView = {
        var view = UIView()
        view.backgroundColor = .systemBackground
        return view
    }()
    
    private var backgroundView2: UIView = {
        var view = UIView()
        view.backgroundColor = .systemBackground
        return view
    }()
    
    init(card: Card) {
        self.card = card
        super.init(nibName: nil, bundle: nil)
        barcodeImage.image = card.loadBarcodeImage()
//        barcodeImage.image = BarcodeGenerator.generateBarcodeWithPackage(barcode: card.barcodeNumbers, codeType: card.barcodeType)
        cardImage.image = card.loadMainImage()
        barcodeNumberLabel.text = card.barcodeNumbers
        barcodeNumberLabel.addCharacterSpacing(kernValue: 5)
        
        //self.title = card.name
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(backgroundView1)
        view.addSubview(backgroundView2)
        view.addSubview(barcodeImage)
        view.addSubview(barcodeNumberLabel)
        view.addSubview(cardImage)
        
        view.backgroundColor = .secondarySystemBackground
        
        setupNavbar()
        
    }
    
    private func setupNavbar() {
        let navbar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 50))
        navbar.backgroundColor = .systemBackground
        navbar.isTranslucent = true
        let navItem = UINavigationItem(title: card.name)
        
        let closeButtonItem = UIBarButtonItem(title: "Закрыть", style: .plain, target: self, action: #selector(close))
        closeButtonItem.tintColor = .orange
        
        let trashImage = UIImage(systemName: "trash.circle.fill")
        
        
        let deleteButtonItem = UIBarButtonItem(image: trashImage, style: .plain, target: self, action: #selector(deleteCard))
        deleteButtonItem.tintColor = .orange
        
        navItem.leftBarButtonItem = closeButtonItem
        navItem.rightBarButtonItem = deleteButtonItem

        navbar.setItems([navItem], animated: false)
        view.addSubview(navbar)
    }
    
    @objc private func close() {
        print("Закрыть")
        dismiss(animated: true)
    }
    
    @objc private func deleteCard() {
        let alert = UIAlertController(title: "Удаление карты", message: "Удалить карту \(card.name)", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: { _ in
            print("Отмена удаления")
        }))
        
        alert.addAction(UIAlertAction(title: "Удалить", style: .destructive, handler: { _ in
            AppModel.shared.deleteCard(card: self.card)
            self.dismiss(animated: true)
        }))
        
        present(alert, animated: true)
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        cardImage.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(80)
            make.leading.trailing.equalToSuperview().inset(80)
            make.height.equalTo(cardImage.snp.width).multipliedBy(1.0 / 1.586)
        }
        
        backgroundView1.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(cardImage.snp.top).offset(-10)
            make.bottom.equalTo(cardImage.snp.bottom).offset(10)
        }
        
        backgroundView2.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(backgroundView1.snp.bottom).offset(20)
            make.bottom.equalTo(barcodeNumberLabel.snp.bottom).offset(20)
        }
        
        barcodeImage.snp.makeConstraints { make in
            make.top.equalTo(backgroundView2.snp.top).offset(50)
            make.leading.trailing.equalToSuperview().inset(40)
        }
        
        barcodeNumberLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(barcodeImage.snp.bottom).offset(50)
        }
        
        
    }
}
