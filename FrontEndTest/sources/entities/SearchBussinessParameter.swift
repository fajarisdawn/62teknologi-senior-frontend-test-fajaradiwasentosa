//
//  SearchBussinessParameter.swift
//  FrontEndTest
//
//  Created by Nur Choirudin on 13/05/23.
//  Copyright © 2023 Fajar Adiwa Sentosa. All rights reserved.
//

import Foundation

// MARK: - SearchBusinessesParameter
struct SearchBusinessesParameter: Codable {
    var location: String?
    var latitude, longitude: Double?
    var term: String?
    var radius: Int?
    var categories: [String]?
    var locale: String?
    var price: [Int]?
    var openNow: Bool?
    var openAt: Int?
    var attributes: [String]?
    var sortBy, devicePlatform, reservationDate, reservationTime: String?
    var reservationCovers: Int?
    var matchesPartySizeParam: Bool?
    var limit, offset: Int?

    init(location: String? = nil,
         latitude: Double?,
         longitude: Double?,
         term: String? = nil,
         radius: Int? = nil,
         categories: [String]? = nil,
         locale: String? = nil,
         price: [Int]? = nil,
         openNow: Bool? = nil,
         openAt: Int? = nil,
         attributes: [String]? = nil,
         sortBy: String? = nil,
         devicePlatform: String? = nil,
         reservationDate: String? = nil,
         reservationTime: String? = nil,
         reservationCovers: Int? = nil,
         matchesPartySizeParam: Bool? = nil,
         limit: Int? = 20,
         offset: Int? = 0) {
        self.location = location
        self.latitude = latitude
        self.longitude = longitude
        self.term = term
        self.radius = radius
        self.categories = categories
        self.locale = locale
        self.price = price
        self.openNow = openNow
        self.openAt = openAt
        self.attributes = attributes
        self.sortBy = sortBy
        self.devicePlatform = devicePlatform
        self.reservationDate = reservationDate
        self.reservationTime = reservationTime
        self.reservationCovers = reservationCovers
        self.matchesPartySizeParam = matchesPartySizeParam
        self.limit = limit
        self.offset = offset
    }
    
    enum CodingKeys: String, CodingKey {
        case location, latitude, longitude, term, radius, categories, locale, price
        case openNow = "open_now"
        case openAt = "open_at"
        case attributes
        case sortBy = "sort_by"
        case devicePlatform = "device_platform"
        case reservationDate = "reservation_date"
        case reservationTime = "reservation_time"
        case reservationCovers = "reservation_covers"
        case matchesPartySizeParam = "matches_party_size_param"
        case limit, offset
    }
    
    func getParams() -> [String: Any] {
        var params = [String: Any]()
        if let location = location {
            params["location"] = location
        }
        
        if let latitude = latitude {
            params["latitude"] = latitude
        }
        
        if let longitude = longitude {
            params["longitude"] = longitude
        }
        
        if let term = term {
            params["term"] = term
        }
        if let radius = radius {
            params["radius"] = radius
        }
        
        if let categories = categories {
            params["categories"] = categories
        }
        
        if let locale = locale {
            params["locale"] = locale
        }
        
        if let price = price {
            params["price"] = price
        }
        
        if let openNow = openNow {
            params["openNow"] = openNow
        }
        
        if let openAt = openAt {
            params["openAt"] = openAt
        }
        
        if let attributes = attributes {
            params["attributes"] = attributes
        }
        
        if let sortBy = sortBy {
            params["sortBy"] = sortBy
        }
        
        if let devicePlatform = devicePlatform {
            params["devicePlatform"] = devicePlatform
        }
        
        if let reservationDate = reservationDate {
            params["reservationDate"] = reservationDate
        }
        
        if let reservationTime = reservationTime {
            params["reservationTime"] = reservationTime
        }
        
        if let reservationCovers = reservationCovers {
            params["reservationCovers"] = reservationCovers
        }
        
        if let matchesPartySizeParam = matchesPartySizeParam {
            params["matchesPartySizeParam"] = matchesPartySizeParam
        }
        
        if let limit = limit {
            params["limit"] = limit
        }
        
        if let offset = offset {
            params["offset"] = offset
        }
        return params
    }
}
