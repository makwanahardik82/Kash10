//
//  UIImage+Extension.swift
//  Peko
//
//  Created by Hardik Makwana on 10/04/23.
//

import UIKit


extension UIImage {
    func toBase64() -> String? {
        return self.jpegData(compressionQuality: 0.5)?.base64EncodedString() ?? ""
    }
    
    func compressTo(_ expectedSizeInKB:Int) -> UIImage? {
        let sizeInBytes = expectedSizeInKB * 1024
        var needCompress:Bool = true
        var imgData:Data?
        var compressingValue:CGFloat = 1.0
        while (needCompress && compressingValue > 0.0) {
            if let data:Data = self.jpegData(compressionQuality: compressingValue) {
                if data.count < sizeInBytes {
                    needCompress = false
                    imgData = data
                } else {
                    compressingValue -= 0.1
                }
            }
        }
        
        if let data = imgData {
            if (data.count < sizeInBytes) {
                return UIImage(data: data)
            }
        }
        return nil
    }
}

