//
//  Availability.swift
//  Touch
//
//  Copyright (c) 2021 EngageCraft. All rights reserved.
//

import Foundation

class ApiCall<W:Codable>{
    typealias dataType = W
    var path:String
    var parameters: [URLQueryItem]?
    
    init(path:String,parameters:[URLQueryItem]? = nil){
        self.path = path
        self.parameters = parameters
    }
    
    public func fetch(_ then: @escaping (W?) -> Void) {
        let request = APIRequest(method: .get, path: path)
        APIManager.shared.perform(request, to: ResponseDataWrapper<W>.self) {(result) in
            switch result{
            case .success(let response):
                DispatchQueue.main.async {
                    then(response.body.data)
                }
            case.failure(let error):
                debugPrint(error)
                DispatchQueue.main.async {
                    then(nil)
                }
            }
        }
    }
}

class ResponseDataWrapper<T:Codable>:Codable{
    var data: T
}

class AvailabilityResponse:Codable{
    var available: Bool
    var params: AvailabilityParams
}

class AvailabilityParams: Codable{
    var height: Int
}

class AvailabilityCall:ApiCall<AvailabilityResponse>{
    convenience init(widgetId:String){
        self.init(path: "v1/widget/\(widgetId)/availability")
    }
}
