//
//  SearchBussinessResponseModel.swift
//  FrontEndTest
//
//  Created by Nur Choirudin on 13/05/23.
//  Copyright © 2023 Fajar Adiwa Sentosa. All rights reserved.
//


import Foundation

// MARK: - SearchBusinessesResponse
struct SearchBusinessesResponse: Codable {
    var businesses: [Business]?
    let total: Int?
    let region: Region?
    
    // MARK: - Business
    struct Business: Codable {
        let id, alias, name: String?
        let imageURL: String?
        let isClosed: Bool?
        let url: String?
        let reviewCount: Int?
        let categories: [Category]?
        let rating: Double?
        let coordinates: Center?
        let transactions: [Transaction]?
        let price: String?
        let location: Location?
        let phone, displayPhone: String?
        let distance: Double?
        let photos: [String]?
        let hours: [Hours]?
        let isClaimed: Bool?
        
        enum CodingKeys: String, CodingKey {
            case id, alias, name
            case imageURL = "image_url"
            case isClosed = "is_closed"
            case isClaimed = "is_claimed"
            case url
            case reviewCount = "review_count"
            case categories, rating, coordinates, transactions, price, location, phone
            case displayPhone = "display_phone"
            case distance
            case photos
            case hours
        }
    }
    
    // MARK: - Category
    struct Coordinates: Codable {
        let latitude, longitude: Double?
    }

    // MARK: - Category
    struct Category: Codable {
        let alias, title: String?
    }

    // MARK: - Center
    struct Center: Codable {
        let latitude, longitude: Double?
    }

    // MARK: - Location
    struct Location: Codable {
        let address1: String?
        let address2: String?
        let address3: String?
        let city: String?
        let zipCode: String?
        let country: String?
        let state: String?
        let displayAddress: [String]?
        
        enum CodingKeys: String, CodingKey {
            case address1, address2, address3, city
            case zipCode = "zip_code"
            case country, state
            case displayAddress = "display_address"
        }
    }

    // MARK: - Region
    struct Region: Codable {
        let center: Center?
    }
    
    enum Transaction: String, Codable {
        case delivery = "delivery"
        case pickup = "pickup"
        case restaurantReservation = "restaurant_reservation"
    }
    
    // MARK: - Hours
    struct Hours: Codable {
        let open: [HoursOpen]?
        let hourType: String?
        let isOpenNow: Bool?
        
        enum CodingKeys: String, CodingKey {
            case open
            case hourType = "hours_type"
            case isOpenNow = "is_open_now"
        }
    }
    
    struct HoursOpen: Codable {
        let isOverNight: Bool
        let start: String
        let end: String
        let day: Int
        
        enum CodingKeys: String, CodingKey {
            case start, end, day
            case isOverNight = "is_overnight"
        }
        
    }
}
