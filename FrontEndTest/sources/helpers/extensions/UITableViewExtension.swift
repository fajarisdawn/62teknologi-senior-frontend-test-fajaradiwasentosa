//
//  UITableViewExtension.swift
//  weather
//
//  Created by Fajar Adiwa Sentosa on 11/06/22.
//  Copyright © 2022 Fajar Adiwa Sentosa. All rights reserved.
//

import Foundation
import UIKit

protocol ReusableCell {
    static var reuseIdentifier: String { get }
    static var nib: UINib? { get }
    static var height: CGFloat { get }
}

extension ReusableCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    static var nib: UINib? {
        guard let _ = Bundle.main.path(forResource: reuseIdentifier, ofType: "nib") else { return nil }
        return UINib(nibName: String(describing: self), bundle: nil)
    }
    
    static var height: CGFloat {
        return 0.0
    }
}

extension UITableView {
    func registerReusableCell<T: UITableViewCell>(_: T.Type) where T: ReusableCell {
        if let nib = T.nib {
            self.register(nib, forCellReuseIdentifier: T.reuseIdentifier)
        } else {
            self.register(T.self, forCellReuseIdentifier: T.reuseIdentifier)
        }
    }
    
    func dequeueReusableCell<T: UITableViewCell>(indexPath: IndexPath) -> T where T: ReusableCell {
        return self.dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as! T
    }

}
