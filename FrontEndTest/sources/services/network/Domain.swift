//
//  Domain.swift
//  weather
//
//  Created by Fajar Adiwa Sentosa on 10/06/22.
//  Copyright © 2022 Fajar Adiwa Sentosa. All rights reserved.
//

import Foundation

protocol Domain {
    var networkService: NetworkService { get set }
    func searchBusinesses(parameter: SearchBusinessesParameter)
    func getBusiness(id: String)
}

extension Domain {
    func searchBusinesses(parameter: SearchBusinessesParameter) {
        networkService.task(network: .searchBusinesses(parameter: parameter), type: SearchBusinessesResponse.self)
    }
    
    func getBusiness(id: String) {
        networkService.task(network: .getBusiness(id: id), type: SearchBusinessesResponse.Business.self)
    }
    
    func getReviews(id: String) {
        networkService.task(network: .getReviews(id: id), type: ReviewResponse.self)
    }
}


