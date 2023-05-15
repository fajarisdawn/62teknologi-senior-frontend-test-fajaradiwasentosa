//
//  UIColor+Extension.swift
//  FrontEndTest
//
//  Created by Nur Choirudin on 13/05/23.
//  Copyright © 2023 Fajar Adiwa Sentosa. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init?(hexString: String) {
        var chars = Array(hexString.hasPrefix("#") ? hexString.dropFirst() : hexString[...])
        switch chars.count {
        case 3: chars = chars.flatMap { [$0, $0] }; fallthrough
        case 6: chars = ["F","F"] + chars
        case 8: break
        default: return nil
        }
        self.init(red: .init(strtoul(String(chars[2...3]), nil, 16)) / 255,
                green: .init(strtoul(String(chars[4...5]), nil, 16)) / 255,
                 blue: .init(strtoul(String(chars[6...7]), nil, 16)) / 255,
                alpha: .init(strtoul(String(chars[0...1]), nil, 16)) / 255)
    }
    
    static func yelpRedColor() -> UIColor? {
        return UIColor(hexString: "#d32323")
    }
}
