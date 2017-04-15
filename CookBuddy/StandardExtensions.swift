//
//  StandardExtensions.swift
//  CookBuddy
//
//  Created by Dominik Horn on 15.04.17.
//  Copyright © 2017 Dominik Horn. All rights reserved.
//

import UIKit

// MARK:-- UIImage
extension UIImage {
    // Initializer for creating emoji image from character
    convenience init(emoji: Character, width: Int = 64, height: Int = 64, fontSize: CGFloat = 60) {
        let size = CGSize(width: width, height: height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0);
        let rect = CGRect(origin: CGPoint(), size: size)
        let nsstring = NSString(string: String(emoji))
        nsstring.draw(in: rect, withAttributes: [NSFontAttributeName: UIFont.systemFont(ofSize: fontSize)])
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        let cgimage: CGImage = image.cgImage!
        self.init(cgImage: cgimage)
    }
}

// MARK:-- Date
extension Date {
    // Compares two dates, returning whether or not they are on the same day
    func isOnSameDayAs(date: Date) -> Bool {
        return Calendar.current.isDate(self, inSameDayAs: date)
    }
}
