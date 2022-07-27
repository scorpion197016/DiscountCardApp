//
//  CreateNewCardViewController.swift
//  DiscountCardAppUIKit
//
//  Created by nikita9x on 10.07.2022.
//

import UIKit
import PhotosUI
import SnapKit
import BarcodeScanner
import RxSwift
import RxCocoa
import NotificationCenter

class CreateNewCardViewController: UIViewController {
    
    let vm = NewCardViewModel()
    
    private var cardImage: UIImageView = {
        let imageView = CardImageView()
        imageView.isUserInteractionEnabled = true
        return imageView
        
    }()
    
    private var barcodeImage: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .orange
        imageView.backgroundColor = .secondarySystemBackground
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private var nameTextField: UITextField = {
        return CustomTextField(placeholder: "Введите название карты")
    }()
    
    
    
    var label: UILabel = {
        var label = UILabel()
        label.text = "Введите название карты"
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    var barcodeNumbersTextfield: UITextField = {
        return CustomTextField(placeholder: "Номер штрихкода")
    }()
    
//    var barcodeTypeLabel: UILabel = {
//        var label = UILabel()
//        label.textColor = .green
//        label.backgroundColor = .blue
//        return label
//    }()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(label)
        view.addSubview(nameTextField)
        view.addSubview(cardImage)
        view.addSubview(barcodeImage)
        view.addSubview(barcodeNumbersTextfield)
        //view.addSubview(barcodeTypeLabel)
        view.backgroundColor = .systemBackground
        
        setupNavbar()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped))
        
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(self.barcodeImageTapped))
        
        cardImage.addGestureRecognizer(tap)
        
        barcodeImage.addGestureRecognizer(tap2)
        
        vm.cardImage.map { value in
            value ?? UIImage(systemName: "photo.circle")
        }
        .bind(to: cardImage.rx.image)
        .disposed(by: disposeBag)
        
        vm.barcodeImage.map { value in
            value ?? UIImage(systemName: "barcode.viewfinder")
        }
        .bind(to: barcodeImage.rx.image)
        .disposed(by: disposeBag)
        
        nameTextField.rx.text.map { value in
            value?.trimmingCharacters(in: CharacterSet(charactersIn: " ")) ?? ""
        }
        .bind(to: vm.name)
        .disposed(by: disposeBag)
        
        barcodeNumbersTextfield.rx.text.bind(to: vm.barcodeNumbers)
            .disposed(by: disposeBag)
        
        vm.barcodeNumbers.subscribe(onNext: { value in
            if value == nil {
                self.barcodeNumbersTextfield.text = "Номер штрихкода"
            } else {
                self.barcodeNumbersTextfield.text = value
            }
        }).disposed(by: disposeBag)
        
//        vm.barcodeType.subscribe(onNext: {value in
//            if value == nil {
//                self.barcodeTypeLabel.text = "Тип баркода"
//            } else {
//                self.barcodeTypeLabel.text = value
//            }
//        }).disposed(by: disposeBag)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)),
                                               name:UIResponder.keyboardWillShowNotification, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)),
                                               name:UIResponder.keyboardWillHideNotification, object: nil);
        
    }
    
    private func setupNavbar() {
        let navbar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 50))
        navbar.backgroundColor = .systemBackground
        navbar.isTranslucent = true
        let navItem = UINavigationItem(title: "Создать карту")
        
        let closeButtonItem = UIBarButtonItem(title: "Закрыть", style: .plain, target: self, action: #selector(close))
        closeButtonItem.tintColor = .orange
        
        let saveButtonItem = UIBarButtonItem(title: "Сохранить", style: .plain, target: self, action: #selector(save))
        saveButtonItem.tintColor = .orange
        vm.isSaveAvailable.bind(to: saveButtonItem.rx.isEnabled).disposed(by: disposeBag)
        
        navItem.leftBarButtonItem = closeButtonItem
        navItem.rightBarButtonItem = saveButtonItem
        navbar.setItems([navItem], animated: false)
        view.addSubview(navbar)
    }
    
    @objc private func close() {
        print("Закрыть")
        dismiss(animated: true)
    }
    
    @objc func imageTapped() {
        let imagePicker = setupImagePicker()
        self.present(imagePicker, animated: true)
    }
    
    @objc func barcodeImageTapped() {
        let barcodeVC = BarcodeScannerViewController()
        barcodeVC.dismissalDelegate = self
        barcodeVC.codeDelegate = self
        barcodeVC.errorDelegate = self
        present(barcodeVC, animated: true)
    }
    
    @objc func save() {
        print("save tapped")
        if vm.saveCard() {
            dismiss(animated: true)
        } else {
            let alert = UIAlertController(title: "Ошибка", message: "Не удалось сохранить", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Закрыть", style: .cancel))
            present(alert, animated: true)
        }
       
        
    }
    
    @objc func keyboardWillShow(sender: NSNotification) {
        if barcodeNumbersTextfield.isEditing {
            self.view.frame.origin.y = -200
        } // Move view 150 points upward
    }
    
    @objc func keyboardWillHide(sender: NSNotification) {
        self.view.frame.origin.y = 0 // Move view to original position
    }
    
    func setupImagePicker() -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.selectionLimit = 1
        config.filter = PHPickerFilter.images
        let pickerVC = PHPickerViewController(configuration: config)
        pickerVC.delegate = self
        return pickerVC
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        cardImage.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(50)
            make.top.equalToSuperview().inset(80)
            make.height.equalTo(cardImage.snp.width).multipliedBy(1.0 / 1.586)
        }
        
        label.snp.makeConstraints { make in
            make.top.equalTo(cardImage).inset(250)
            make.leading.equalToSuperview().inset(40)
        }
        
        nameTextField.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(40)
            make.height.equalTo(30)
        }
        
        barcodeImage.snp.makeConstraints { make in
            make.top.equalTo(nameTextField).inset(50)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(40)
            make.height.equalTo(90)
        }
        
        barcodeNumbersTextfield.snp.makeConstraints { make in
            make.top.equalTo(barcodeImage).inset(150)
            make.centerX.equalToSuperview()
            make.height.equalTo(30)
            make.width.greaterThanOrEqualTo(200)
        }
        
//        barcodeTypeLabel.snp.makeConstraints { make in
//            make.top.equalTo(barcodeNumbersTextfield)
//            make.trailing.equalToSuperview().inset(40)
//            make.height.equalTo(50)
//        }
    }
}

extension CreateNewCardViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        
        for result in results {
            result.itemProvider.loadObject(ofClass: UIImage.self, completionHandler: { (object, error) in
                if let image = object as? UIImage {
                    DispatchQueue.main.async {
                        // Use UIImage
                        print("Selected image: \(image)")
                        self.vm.cardImage.accept(image)
                    }
                }
            })
        }
    }
}

extension CreateNewCardViewController: BarcodeScannerErrorDelegate {
    func scanner(_ controller: BarcodeScannerViewController, didReceiveError error: Error) {
        print(error)
    }
}

extension CreateNewCardViewController: BarcodeScannerDismissalDelegate {
    func scannerDidDismiss(_ controller: BarcodeScannerViewController) {
        controller.dismiss(animated: true)
    }
    
    
}

extension CreateNewCardViewController: BarcodeScannerCodeDelegate {
    func scanner(_ controller: BarcodeScannerViewController, didCaptureCode code: String, type: String) {
        print(code, type)
        vm.scanBarCode(code: code, type: type)
        controller.dismiss(animated: true)
    }
    
    
}
