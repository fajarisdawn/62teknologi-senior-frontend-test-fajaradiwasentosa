//
//  HomeViewModel.swift
//  FrontEndTest
//
//  Created by Nur Choirudin on 13/05/23.
//  Copyright © 2023 Fajar Adiwa Sentosa. All rights reserved.
//

import Foundation

protocol HomeViewModelConstructor {
    var bussinessModel: SearchBusinessesResponse? { get set }
    var businessesParameter: SearchBusinessesParameter? { get set }
    var isEndPage: Bool { get set }
    var loadMore: Bool { get set }
}

protocol HomeViewModelInteractor {
    func reloadData()
}

class HomeViewModel: Domain, HomeViewModelConstructor {
    var bussinessModel: SearchBusinessesResponse?
    var businessesParameter: SearchBusinessesParameter?
    var networkService: NetworkService = NetworkService()
    var interactor: ViewModelInteractor?
    var isEndPage: Bool = false
    var loadMore: Bool = false {
        didSet {
            if self.loadMore {
                if let offset = businessesParameter?.offset {
                    businessesParameter?.offset = offset + 20
                }
            }
        }
    }
    
    init() {
        self.networkService.interactor = self
    }
}

extension HomeViewModel: NetworkServiceInteractor {
    func success(_ object: Codable, network: Network) {
        guard let `object` = object as? SearchBusinessesResponse else {
            interactor?.failed("Failed populate data")
            return
        }
        
        interactor?.success(network)

        if loadMore {
            bussinessModel?.businesses?.append(contentsOf: object.businesses ?? [])
        } else {
            bussinessModel = object
        }
        
        loadMore = false
    }
    
    func failed(_ message: String, network: Network) {
        interactor?.failed(message)
    }
}
