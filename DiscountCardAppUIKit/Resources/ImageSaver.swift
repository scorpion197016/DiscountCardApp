//
//  ImageSaver.swift
//  DiscountCardAppUIKit
//
//  Created by nikita9x on 09.07.2022.
//

import Foundation
import UIKit

class ImageUtil {
    static func retriveImage(forKey key: String) -> UIImage? {
        if let filePath = filePath(forKey: key),
           let fileData = FileManager.default.contents(atPath: filePath.path),
           let image = UIImage(data: fileData) {
            return image
        }
        return nil
    }
    
    static func store(image: UIImage, forKey key: String) {
        if let pngRepresentation = image.pngData() {
            if let filePath = filePath(forKey: key) {
                do {
                    try pngRepresentation.write(to: filePath, options: .atomic)
                } catch {
                    print("Saving file resulted in err: ", error)
                }
            }
        }
    }
    
    static func delete(forKey key: String) {
        if let filePath = filePath(forKey: key) {
            do {
                try FileManager.default.removeItem(atPath: filePath.path)
            }  catch {
                print("Error deleting data: err", error)
            }
        }
    }
    static private func filePath(forKey key: String) -> URL? {
        let fileManager = FileManager.default
        guard let documentURL = fileManager.urls(for: .documentDirectory,
                                                in: FileManager.SearchPathDomainMask.userDomainMask).first else { return nil }
        
        return documentURL.appendingPathComponent(key + ".png")
    }
}
