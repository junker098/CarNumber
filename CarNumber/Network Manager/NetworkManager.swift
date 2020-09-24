//
//  NetworkManager.swift
//  CarNumber
//
//  Created by Юрий Могорита on 11.09.2020.
//  Copyright © 2020 Yuri Mogorita. All rights reserved.
//

import Foundation
import Alamofire

class AlamofireNetworkRequest {
    
    static let shared = AlamofireNetworkRequest()
    private init() {}
    
    func sendRequest(url: String, completion: @escaping (_ car: Car) -> ()) {
        
        let urll = URL(string: url)
        let headers: HTTPHeaders = ["Accept" : "application/json"]
        guard let url = urll else { return }
        AF.request(url, headers: headers).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                print(value)
                guard let data = response.data  else { return }
                do {
                    let car = try JSONDecoder().decode(Car.self, from: data)
                    completion(car)
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

