//
//  FailedRequest.swift
//  InfiniumTest
//
//  Created by andrii on 06/03/2021.
//

import Foundation
import Moya


protocol FailedRequestProtocol {
    func resend()
    var finished:Bool { get set }
}

class FailedRequest<T: Codable> : FailedRequestProtocol {
    var finished: Bool = false
    public var request: BreweryDBAPI
    public var completionHandler: (Error?, T?) -> ()
        
    init(request: BreweryDBAPI, completion: @escaping (Error?, T?) -> ()) {
        self.request = request
        self.completionHandler = completion
    }
    
    public func resend() {
        if !finished {
            finished = true
            _ = ApiService.shared.sendUpgraded(request: request, completion: { (error: Error?,  data: T?) in
                self.completionHandler(error, data)
            })
        }
    }
}
