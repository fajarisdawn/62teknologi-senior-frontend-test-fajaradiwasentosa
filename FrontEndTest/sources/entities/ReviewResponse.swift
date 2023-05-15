//
//  ReviewResponse.swift
//  FrontEndTest
//
//  Created by fajaradiwasentosa on 15/05/23.
//  Copyright © 2023 Fajar Adiwa Sentosa. All rights reserved.
//

import Foundation

struct ReviewResponse: Codable {
    let reviews: [Review]
    let total: Int
    let language: [String]
    
    enum CodingKeys: String, CodingKey {
        case reviews, total
        case language = "possible_languages"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.reviews = try container.decodeIfPresent([Review].self, forKey: .reviews) ?? []
        self.total = try container.decodeIfPresent(Int.self, forKey: .total) ?? 0
        self.language = try container.decodeIfPresent([String].self, forKey: .language) ?? []
    }
    
    struct Review: Codable {
        var id: String
        let url: String
        let text: String
        let rating: Double
        let timeCreated: String
        var user: User?
        
        enum CodingKeys: String, CodingKey {
            case id, url, text, rating, user
            case timeCreated = "time_created"
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.id = try container.decodeIfPresent(String.self, forKey: .id) ?? ""
            self.url = try container.decodeIfPresent(String.self, forKey: .url) ?? ""
            self.text = try container.decodeIfPresent(String.self, forKey: .text) ?? ""
            self.rating = try container.decodeIfPresent(Double.self, forKey: .rating) ?? 0
            self.user = try container.decodeIfPresent(User.self, forKey: .user) ?? nil
            self.timeCreated = try container.decodeIfPresent(String.self, forKey: .timeCreated) ?? ""
        }
        
        struct User: Codable {
            let id: String
            let profileUrl: String
            let imageUrl: String
            let name: String
            
            enum CodingKeys: String, CodingKey {
                case id, name
                case profileUrl = "profile_url"
                case imageUrl = "image_url"
            }
            
            public init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                self.id = try container.decodeIfPresent(String.self, forKey: .id) ?? ""
                self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
                self.imageUrl = try container.decodeIfPresent(String.self, forKey: .profileUrl) ?? ""
                self.profileUrl = try container.decodeIfPresent(String.self, forKey: .imageUrl) ?? ""
            }
        }
    }
}

