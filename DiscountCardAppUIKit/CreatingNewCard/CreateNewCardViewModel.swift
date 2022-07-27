//
//  CreateNewCardViewModel.swift
//  DiscountCardAppUIKit
//
//  Created by nikita9x on 23.07.2022.
//

import Foundation
import RxSwift
import RxCocoa


class NewCardViewModel {
    
    public var name: BehaviorRelay<String> = BehaviorRelay(value: "")
    var barcodeNumbers: BehaviorRelay<String?> = BehaviorRelay(value: nil)
    var barcodeImage: BehaviorRelay<UIImage?> = BehaviorRelay(value: nil)
    var cardImage: BehaviorRelay<UIImage?> = BehaviorRelay(value: nil)
    var barcodeType: BehaviorRelay<String?> = BehaviorRelay(value: "org.gs1.EAN-13")
    
    public var isSaveAvailable: Observable<Bool> {

        return Observable.combineLatest(cardImageValid, barcodeValid, nameValid) { a, b, c in
            print(a, b, c)
            return a&&b&&c
        }
        .distinctUntilChanged()
    }
    
    public func scanBarCode(code: String, type: String) {
        barcodeType.accept(type)
        barcodeNumbers.accept(code)
    }
    private let disposeBag = DisposeBag()
    init() {
        Observable.combineLatest(barcodeType, barcodeNumbers) { type, numbers -> UIImage? in
            if let type = type, let numbers = numbers {
                return BarcodeGenerator.generateBarcodeWithPackage(barcode: numbers, codeType: type)
            }
            return nil
        }
        .distinctUntilChanged()
        .bind(to: barcodeImage)
        .disposed(by: disposeBag)
        
    }
    
    private var cardImageValid: Observable<Bool> {
        return cardImage.asObservable().map {
            return $0 != nil
        }
        .distinctUntilChanged()
    }
    
    private var nameValid: Observable<Bool> {
        return name.asObservable().map { _ in
            return self.validateName()
        }
        .distinctUntilChanged()
    }
    
    private var barcodeValid: Observable<Bool> {
        return Observable.combineLatest(barcodeNumbers, barcodeType).map { _, _ in
            return self.validateBarcode()
        }
        .distinctUntilChanged()
    }
    
    
    
    private func validateName() -> Bool {
        guard validateLength(text: name.value, size: (2, 18)) else {
            return false
        }
        return true
    }
    
    private func validateBarcode() -> Bool {
        return CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: barcodeNumbers.value ?? ""))
            && barcodeImage.value != nil && barcodeType.value != nil
    }
    
    public func saveCard() -> Bool {
        let card = Card()
        card.name = name.value
        card.barcodeNumbers = barcodeNumbers.value!
        card.barcodeType = barcodeType.value!
        
        return AppModel.shared.addCard(card: card,
                                mainImage: cardImage.value!,
                                barcodeImage: barcodeImage.value!)
    }
    
    private func validateLength(text: String, size: (min: Int, max: Int)) -> Bool {
        return (size.min...size.max).contains(text.count)
    }
}
