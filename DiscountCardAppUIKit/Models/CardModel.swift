//
//  CardModel.swift
//  DiscountCardAppUIKit
//
//  Created by nikita9x on 09.07.2022.
//

import Foundation
import RealmSwift
import UIKit


class Card: Object {
    @Persisted(primaryKey: true) var name: String = ""
    @Persisted var barcodeNumbers: String = ""
    @Persisted var barcodeType: String = ""
    
    private static let realm = try! Realm()
}

extension Card {
    func saveMainImage(image: UIImage) {
        ImageUtil.store(image: image, forKey: self.name + "main_image")
    }
    
    func loadMainImage() -> UIImage? {
        ImageUtil.retriveImage(forKey: self.name + "main_image")
    }
    
    func saveBarcodeImage(image: UIImage) {
        ImageUtil.store(image: image, forKey: self.name + "code_image")
    }
    
    func loadBarcodeImage() -> UIImage? {
        ImageUtil.retriveImage(forKey: self.name + "code_image")
    }
    
    func deleteMainImage() {
        ImageUtil.delete(forKey: self.name + "main_image")
    }
    
    func deleteBarcodeImage() {
        ImageUtil.delete(forKey: self.name + "code_image")
    }
}
