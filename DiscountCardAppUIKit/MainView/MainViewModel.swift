//
//  MainViewModel.swift
//  DiscountCardAppUIKit
//
//  Created by nikita9x on 25.07.2022.
//

import Foundation
import RxSwift
import RxCocoa
import RealmSwift

class MainViewModel {
    private let appModel = AppModel.shared
    public static let shared = MainViewModel()
    
    private var allCards: BehaviorRelay<[Card]> = BehaviorRelay(value: [])
    private var showedCards:  BehaviorRelay<[Card]> = BehaviorRelay(value: [])
    public var cards: BehaviorRelay<[Card]> {
        return showedCards
    }
    public var searchQuery: BehaviorRelay<String> = BehaviorRelay(value: "")
    
    private let disposeBag = DisposeBag()
    
    public func deleteCardAtIndex(index: Int) {
        let card = showedCards.value[index]
        appModel.deleteCard(card: card)
    }
    private init() {
        appModel.cards.bind(to: allCards).disposed(by: disposeBag)
        
        Observable.combineLatest(allCards, searchQuery) { cards, query in
            print(query)
            if query == "" {
                return cards
            }
            else {
                return cards.filter { card in
                    card.name.lowercased().contains(query.lowercased())
                }
            }
        }
        .bind(to: showedCards)
        .disposed(by: disposeBag)
    }
}
