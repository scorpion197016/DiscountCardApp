//
//  BarcodeGenerator.swift
//  DiscountCardAppUIKit
//
//  Created by nikita9x on 09.07.2022.
//

import Foundation
import CoreImage
import UIKit
import RSBarcodes_Swift
import AVFoundation

class BarcodeGenerator {
//    static func generateBarcode(barcode: String) -> UIImage {
//        let data = barcode.data(using: .ascii)
//        guard let filter = CIFilter(name: "CICode128BarcodeGenerator") else {
//            fatalError("generate barcode error")
//        }
//        filter.setValue(data, forKey: "inputMessage")
//        guard let ciImage = filter.outputImage else {
//            fatalError("generate barcode error")
//        }
//        
//        return UIImage(ciImage: ciImage)
//    }
    
    static func generateBarcodeWithPackage(barcode: String, codeType: AVMetadataObject.ObjectType) -> UIImage {
        RSUnifiedCodeGenerator.shared.generateCode(barcode, machineReadableCodeObjectType: codeType.rawValue)!
    }
    
    static func generateBarcodeWithPackage(barcode: String, codeType: String) -> UIImage? {
        RSUnifiedCodeGenerator.shared.generateCode(barcode, machineReadableCodeObjectType: codeType)
    }
}


