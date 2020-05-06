//
//  NetworkingClient.swift
//  OnisPos
//
//  Created by MG on 4/16/20.
//  Copyright © 2020 MG. All rights reserved.
//


import UIKit
import Alamofire
import SwiftyJSON

let networkingClient = NetworkingClient()

class NetworkingClient {
    
    typealias WebServiceResponce = (JSON?, Error?) -> Void
    
    func executePost(_suburl: String, parameters: Parameters, completion: @escaping WebServiceResponce) {
        guard let url = URL(string: BASE_URL + _suburl) else { return }
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 30

        let headers = getHeaders()
        manager.request(url,method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate().responseJSON{ response in
            print(response)
            switch response.result {
                case .failure(let error):
                    print(error)
                    completion(nil, error)
                case .success(let value):
                    let json = JSON(value)
                    print(json)
                    completion(json, nil)
            }
        }
    }
    
    func executePut(_suburl: String, parameters: Parameters, completion: @escaping WebServiceResponce) {
        guard let url = URL(string: BASE_URL + _suburl) else { return }
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 30
        
        let headers = getHeaders()
        manager.request(url,method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate().responseJSON{ response in
            print(response)
            switch response.result {
            case .failure(let error):
                print(error)
                completion(nil, error)
            case .success(let value):
                let json = JSON(value)
                print(json)
                completion(json, nil)
            }
        }
    }
    
    func executeGet(_suburl: String, parameters: Parameters, completion: @escaping WebServiceResponce) {
        guard let url = URL(string: BASE_URL + _suburl) else { return }
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 30
        
        let headers = getHeaders()
        
        Alamofire.request(url,method: .get,  encoding: JSONEncoding.default, headers: headers).validate().responseJSON{ response in
            print(response)
            switch response.result {
            case .failure(let error):
                print(error)
                completion(nil, error)
            case .success(let value):
                let json = JSON(value)
                print(json)
                completion(json, nil)
            }
        }
    }
    
    func executeDelete(_suburl: String, parameters: Parameters, completion: @escaping WebServiceResponce) {
        guard let url = URL(string: BASE_URL + _suburl) else { return }
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 30
        
        let headers = getHeaders()
        
        Alamofire.request(url,method: .delete, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate().responseJSON{ response in
            print(response)
            switch response.result {
            case .failure(let error):
                print(error)
                completion(nil, error)
            case .success(let value):
                let json = JSON(value)
                print(json)
                completion(json, nil)
            }
        }
    }
    
    func getHeaders() -> HTTPHeaders {
        var token = UserDefaults.standard.string(forKey: "token")!
        token = "Bearer " + token
        var headers : HTTPHeaders = [
            "Content-Type":"application/json; charset=utf-8",
            "Accept": "application/json",
            "Authorization": token
        ]
        if(token.count == 7){
            headers.removeValue(forKey: "Authorization")
        }
        return headers
    }
    
}
