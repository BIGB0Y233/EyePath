//
//  ImageLoadingTool.swift
//  ARNavigation
//
//  Created by ck on 2023/3/23.
//

import SwiftUI

func loadImageFromPath(path: String) -> UIImage {
    let urlString=NSHomeDirectory()+"/Documents/\(path)"
    guard let image = UIImage(contentsOfFile: urlString) else {
        let size = CGSize(width: 100, height: 100)
        let renderer = UIGraphicsImageRenderer(size: size)
        let whiteImage = renderer.image { context in
            UIColor.yellow.setFill()
            context.fill(CGRect(origin: .zero, size: size))
        }
        return whiteImage
    }
    let result = image.rotate(radians: .pi/2)
    return result
}

func deleteImage(imageName:String){
    let fileManager = FileManager.default
    do {
        let imagePath = URL(fileURLWithPath: NSHomeDirectory()+"/Documents/\(imageName)")
        try fileManager.removeItem(at: imagePath)
    } catch {
        print("Error while deleting file: \(error.localizedDescription)")
    }
}

extension UIImage {
    func rotate(radians: CGFloat) -> UIImage {
        let rotatedSize = CGRect(origin: .zero, size: size)
            .applying(CGAffineTransform(rotationAngle: CGFloat(radians)))
            .integral.size
        UIGraphicsBeginImageContext(rotatedSize)
        if let context = UIGraphicsGetCurrentContext() {
            let origin = CGPoint(x: rotatedSize.width / 2.0,
                                 y: rotatedSize.height / 2.0)
            context.translateBy(x: origin.x, y: origin.y)
            context.rotate(by: radians)
            draw(in: CGRect(x: -origin.y,
                            y: -origin.x,
                            width: size.width,
                            height: size.height))
            let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return rotatedImage ?? self
        }
        return self
    }
}
