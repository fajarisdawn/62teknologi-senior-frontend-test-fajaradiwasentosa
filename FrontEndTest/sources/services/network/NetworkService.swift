//
//  NetworkService.swift
//  weather
//
//  Created by Fajar Adiwa Sentosa on 10/06/22.
//  Copyright © 2022 Fajar Adiwa Sentosa. All rights reserved.
//

import Foundation

protocol NetworkServiceInteractor {
    func success(_ object: Codable, network: Network)
    func failed(_ message: String, network: Network)
}

class NetworkService {
    var interactor: NetworkServiceInteractor?
    var dataTask: URLSessionDataTask?
    
    func task<T: Codable>(network: Network, type: T.Type) {
        if let `dataTask` = dataTask {
            if dataTask.state != .running {
                request(network, type: type)
            } else {
                dataTask.cancel()
                request(network, type: type)
            }
        }

        request(network, type: type)
    }
    
    private
    func request<T: Codable>(_ network: Network, type: T.Type) {
        let urlString = network.baseUrl.appendingPathComponent(network.path).absoluteString.removingPercentEncoding
        guard let url = URL(string: urlString ?? "") else { return }
        var request = URLRequest(url: url)
        request.setValue("Bearer \(NetworkProperties.apiKey)", forHTTPHeaderField: "Authorization")
        let session = URLSession.shared.dataTask(with: request) { (data, urlResponse, error) in
            if let error = error {
                self.interactor?.failed(error.localizedDescription, network: network)
                return
            }
            
            guard let `data` = data else { return }
            let response = APIData(data: data)
            
            guard let object = response.decode(type) else {
                self.interactor?.failed("Failed populate data", network: network)
                return
            }
           
            
            self.interactor?.success(object, network: network)
        }
        
        session.resume()
        
    }
}
