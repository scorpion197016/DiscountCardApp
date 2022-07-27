//
//  MainViewController.swift
//  DiscountCardAppUIKit
//
//  Created by nikita9x on 09.07.2022.
//

import UIKit
import SnapKit
import RxSwift
import RxDataSources
import RxCocoa

class MainViewController: UIViewController {
    
    var appModel = MainViewModel.shared
    
    let disposeBag = DisposeBag()
    
    private let collectionView: UICollectionView = {
        var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewCompositionalLayout(
            sectionProvider: {_, _ -> NSCollectionLayoutSection? in
                let item = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .fractionalHeight(1)))
                item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 7, bottom: 2, trailing: 7)

                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .fractionalWidth(1 / 2 / 1.2)),
                    subitem: item,
                    count: 2)

                group.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0)

                return NSCollectionLayoutSection(group: group)
            }))
        collectionView.register(CardCollectionViewCell.self, forCellWithReuseIdentifier: CardCollectionViewCell.identifier)
        collectionView.backgroundColor = .systemBackground
        return collectionView
    }()
    
    
    var searchController: UISearchController = {
        let vc = UISearchController()
        vc.searchBar.placeholder = "Поиск"
        vc.searchBar.searchBarStyle = .minimal
        vc.definesPresentationContext = true
        return vc
    }()
    
    var addButton: UIButton = {
        var button = UIButton()
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.backgroundColor = .systemOrange
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        view.addSubview(addButton)
        
        view.backgroundColor = .secondarySystemBackground
        addButton.addTarget(self, action: #selector(self.addTapped), for: .touchUpInside)
        
        collectionView.rx.modelSelected(Card.self).subscribe(onNext: { card in
            print(card.name)
            let vc = CardDetailsViewController(card: card)
            self.present(vc, animated: true)
        }).disposed(by: disposeBag)
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gestureRecognizer:)))
        longPressGestureRecognizer.delegate = self
        longPressGestureRecognizer.minimumPressDuration = 0.5
        longPressGestureRecognizer.delaysTouchesBegan = true
        collectionView.addGestureRecognizer(longPressGestureRecognizer)
        appModel.cards.bind(to: collectionView.rx.items(cellIdentifier: CardCollectionViewCell.identifier, cellType: CardCollectionViewCell.self)) {
            index, card, cell in
            cell.configure(with: card)
        }.disposed(by: disposeBag)
        
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.backgroundColor = .secondarySystemBackground
        navigationController?.navigationBar.isTranslucent = true
        
        navigationItem.searchController = searchController
        
        let addBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addTapped))
        addBarButtonItem.tintColor = .orange
        navigationItem.setRightBarButton(addBarButtonItem, animated: true)
        navigationItem.rightBarButtonItem = addBarButtonItem
        
        searchController.searchBar.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        
        collectionView.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().inset(50)
        }
        //navigationController?.navigationBar.frame = CGRect(x: 0, y: -50, width: view.frame.width, height: 100)
    }
    
    
    @objc func addTapped() {
        print("add tapped")
        present(CreateNewCardViewController(), animated: true)
    }
    
    @objc func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer) {
        if (gestureRecognizer.state != UIGestureRecognizer.State.began) {
            return
        }
        
        let p = gestureRecognizer.location(in: collectionView)
        
        if let indexPath = self.collectionView.indexPathForItem(at: p) {
            let card =  appModel.cards.value[indexPath.row]
            let alert = UIAlertController(title: "Удаление карты", message: "Удалить карту \(card.name)", preferredStyle: .actionSheet)
            
            alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: { _ in
                print("Отмена удаления")
            }))
            
            alert.addAction(UIAlertAction(title: "Удалить", style: .destructive, handler: { _ in
                self.appModel.deleteCardAtIndex(index: indexPath.row)
                print("delete at:", indexPath.row)
            }))
            
            present(alert, animated: true)
            
        }
    }
}

extension MainViewController: UIGestureRecognizerDelegate {
    
}

extension MainViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        appModel.searchQuery.accept(searchText)
    }
}
