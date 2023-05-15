//
//  Reachability.swift
//  weather
//
//  Created by Fajar Adiwa Sentosa on 11/06/22.
//  Copyright © 2022 Fajar Adiwa Sentosa. All rights reserved.
//

import Foundation
import Network

class Reachability {
    var pathMonitor: NWPathMonitor!
    var path: NWPath?
    static let shared = Reachability()
    
    lazy var pathUpdateHandler: ((NWPath) -> Void) = { path in
        self.path = path
        if path.status == NWPath.Status.satisfied {
            print("Connected")
        } else if path.status == NWPath.Status.unsatisfied {
            print("unsatisfied")
        } else if path.status == NWPath.Status.requiresConnection {
            print("requiresConnection")
        }
    }
    
    let backgroudQueue = DispatchQueue.global(qos: .background)
    
    init() {
        pathMonitor = NWPathMonitor()
        pathMonitor.pathUpdateHandler = self.pathUpdateHandler
        pathMonitor.start(queue: backgroudQueue)
    }
    
    func isNetworkAvailable() -> Bool {
        if let path = self.path {
            if path.status == NWPath.Status.satisfied {
                return true
            }
        }
        return false
    }
}
