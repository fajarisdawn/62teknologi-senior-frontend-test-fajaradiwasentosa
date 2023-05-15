//
//  ViewModelInteractor.swift
//  weather
//
//  Created by Fajar Adiwa Sentosa on 11/06/22.
//  Copyright © 2022 Fajar Adiwa Sentosa. All rights reserved.
//

import Foundation

protocol ViewModelInteractor {
    func success(_ network: Network)
    func failed(_ message: String)
}
