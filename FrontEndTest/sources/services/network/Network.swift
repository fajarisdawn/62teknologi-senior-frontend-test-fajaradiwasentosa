//
//  Network.swift
//  weather
//
//  Created by Fajar Adiwa Sentosa on 10/06/22.
//  Copyright © 2022 Fajar Adiwa Sentosa. All rights reserved.
//

import Foundation

protocol EndpointType {
    var baseUrl: URL { get }
    var path: String { get }
}

enum Network {
    case none
    case searchBusinesses(parameter: SearchBusinessesParameter)
    case getBusiness(id: String)
    case getReviews(id: String)
}

extension Network: EndpointType {
    var baseUrl: URL {
        return URL(string: "https://api.yelp.com/v3/")!
    }
    
    var path: String {
        switch self {
        case .searchBusinesses(let parameter):
            return "businesses/search?\(parameter.getParams().toQueryString())"
        case .getBusiness(let id):
            return "businesses/\(id)"
        case .getReviews(let id):
            return "businesses/\(id)/reviews?limit=10&sort_by=newest"
        default:
            return ""
        }
    }
}
