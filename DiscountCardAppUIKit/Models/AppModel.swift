//
//  AppViewModel.swift
//  DiscountCardAppUIKit
//
//  Created by nikita9x on 09.07.2022.
//

import RxSwift
import RealmSwift
import RxRealm

class AppModel {
    static let shared: AppModel = AppModel()
    private let realm: Realm
    private let _cards: Results<Card>
    
    public var cards: Observable<[Card]>
    private let bag = DisposeBag()
    
    private init() {
        realm = try! Realm()
        _cards = realm.objects(Card.self)
        
        cards = Observable.array(from: _cards)
    }
    
//    public func updateCard(card: Card) {
//        try! realm.write {
//            realm.add(card, update: .modified)
//        }
//    }
    
    public func addCard(card: Card, mainImage: UIImage, barcodeImage: UIImage) -> Bool {
        if _cards.contains(where: { elem in
            elem.name == card.name
        }) {
            return false
        }
        else {
            try! realm.write {
                 realm.add(card)
            }
            card.saveMainImage(image: mainImage)
            card.saveBarcodeImage(image: barcodeImage)
            return true
        }
    }
    
    public func deleteCard(card: Card) {
        card.deleteMainImage()
        card.deleteBarcodeImage()
        try! realm.write {
            realm.delete(card)
        }
    }
}
