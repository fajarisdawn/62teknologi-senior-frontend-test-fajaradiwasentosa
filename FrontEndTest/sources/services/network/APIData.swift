//
//  APIData.swift
//  weather
//
//  Created by Fajar Adiwa Sentosa on 10/06/22.
//  Copyright © 2022 Fajar Adiwa Sentosa. All rights reserved.
//

import Foundation

struct APIData {
    fileprivate var data: Data
    
    init(data: Data) {
        self.data = data
    }
}

extension APIData {
    public func decode<T: Codable>(_ type: T.Type) -> T? {
        let jsonDecoder = JSONDecoder()
        do {
            let response = try jsonDecoder.decode(T.self, from: data)
            return response
        } catch {
            return nil
        }
    }
}
