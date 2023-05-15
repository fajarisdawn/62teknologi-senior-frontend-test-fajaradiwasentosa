//
//  DateExtension.swift
//  weather
//
//  Created by Fajar Adiwa Sentosa on 11/06/22.
//  Copyright © 2022 Fajar Adiwa Sentosa. All rights reserved.
//

import UIKit

extension Date {
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).capitalized
    }
}
