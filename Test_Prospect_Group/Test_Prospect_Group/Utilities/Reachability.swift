//
//  Reachability.swift
//  Test_Prospect_Group
//
//  Created by Maxim Biriukov on 6/15/18.
//  Copyright © 2018 Eugene Chepelev. All rights reserved.
//

import Alamofire

class Reachability {
    
    let reachabilityManager = Alamofire.NetworkReachabilityManager(host: "www.apple.com")
    
    func listenForReachability(with completion: @escaping (Bool) -> Void) {
        self.reachabilityManager?.listener = { status in
            switch status {
            case .notReachable:
                completion(false)
            case .reachable(_), .unknown:
                completion(true)
            }
        }
        
        reachabilityManager?.startListening()
    }
    
    static var isConnectedToInternet: Bool {
        return NetworkReachabilityManager()!.isReachable
    }
    
}
