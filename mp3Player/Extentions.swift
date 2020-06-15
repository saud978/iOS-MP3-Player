//
//  Extentions.swift
//  mp3Player2
//
//  Created by Saud Almutlaq on 06/10/2018.
//  Copyright © 2018 saudsoft.com. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    var isPortrait:  Bool    { return size.height > size.width }
    var isLandscape: Bool    { return size.width > size.height }
    var breadth:     CGFloat { return min(size.width, size.height) }
    var breadthSize: CGSize  { return CGSize(width: breadth, height: breadth) }
    var breadthRect: CGRect  { return CGRect(origin: .zero, size: breadthSize) }
    func rounded(with color: UIColor, width: CGFloat) -> UIImage? {
        let bleed = breadthRect.insetBy(dx: -width, dy: -width)
        UIGraphicsBeginImageContextWithOptions(bleed.size, false, scale)
        defer { UIGraphicsEndImageContext() }
        guard let cgImage = cgImage?.cropping(to: CGRect(origin: CGPoint(
            x: isLandscape ? ((size.width-size.height)/2).rounded(.down) : 0,
            y: isPortrait  ? ((size.height-size.width)/2).rounded(.down) : 0),
                                                         size: breadthSize))
            else { return nil }
        UIBezierPath(ovalIn: CGRect(origin: .zero, size: bleed.size)).addClip()
        var strokeRect =  breadthRect.insetBy(dx: -width/2, dy: -width/2)
        strokeRect.origin = CGPoint(x: width/2, y: width/2)
        UIImage(cgImage: cgImage, scale: 1, orientation: imageOrientation).draw(in: strokeRect.insetBy(dx: width/2, dy: width/2))
        color.set()
        let line = UIBezierPath(ovalIn: strokeRect)
        line.lineWidth = width
        line.stroke()
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
