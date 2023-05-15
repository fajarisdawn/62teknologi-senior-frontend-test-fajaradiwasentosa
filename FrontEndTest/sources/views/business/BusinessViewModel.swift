//
//  BusinessViewModel.swift
//  FrontEndTest
//
//  Created by fajaradiwasentosa on 15/05/23.
//  Copyright © 2023 Fajar Adiwa Sentosa. All rights reserved.
//

import Foundation


class BusinessViewModel: Domain {
    var networkService: NetworkService = NetworkService()
    var interactor: ViewModelInteractor?
    var businessId: String = ""
    var reviewResponse: ReviewResponse?
    var businessResponse: SearchBusinessesResponse.Business?
    
    init() {
        networkService.interactor = self
    }
}

extension BusinessViewModel: NetworkServiceInteractor {
    func success(_ object: Codable, network: Network) {
        switch network {
        case .getBusiness:
            let object: SearchBusinessesResponse.Business = object as! SearchBusinessesResponse.Business
            businessResponse = object
        default:
            let object: ReviewResponse = object as! ReviewResponse
            reviewResponse = object
        }
        
        interactor?.success(network)
    }
    
    func failed(_ message: String, network: Network) {
        interactor?.failed(message)
    }
    
    
}
