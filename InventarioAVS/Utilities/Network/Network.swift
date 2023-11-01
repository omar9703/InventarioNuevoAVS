//
//  Network.swift
//  InventarioAVS
//
//  Created by IDS Comercial on 11/01/22.
//

import Foundation
import UIKit

enum typeRequest : String {
    case POST
    case GET
    case DELETE
}

func requestPetition<T : Decodable>(ofType type:T.Type,typeRequest : typeRequest, url : String, parameters : [String:Any] = [String:Any](),header : String = "",completion: @escaping (Int, T?)->Void){
    var dataReturn : T?
    var requestParams = URLRequest(url: URL(string: url)!)
    var Bearer : String = ""
    var httpResponseCode : Int = 0
    debugPrint(url)
    switch typeRequest {
    case .POST:
        requestParams.setValue("application/json", forHTTPHeaderField: "Content-Type")
        requestParams.httpMethod = typeRequest.rawValue
        break
    case .GET:
        requestParams.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if header != ""
        {
            requestParams.setValue(header, forHTTPHeaderField: "value")
        }
        break
    case .DELETE:
        requestParams.setValue("application/json", forHTTPHeaderField: "Content-Type")
        break
    }
    
    if !parameters.isEmpty{
        requestParams.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
    }
    
    let task = URLSession.shared.dataTask(with: requestParams) {(data, response, error) in
        if let httpResponse = response as? HTTPURLResponse {
            httpResponseCode = httpResponse.statusCode
            debugPrint(httpResponse.statusCode)
        }
       debugPrint(String(data: data ?? Data(), encoding: .utf8)!)
        let decoder = JSONDecoder()
        do {
            let dataResponse = try decoder.decode(type, from: data ?? Data())
            dataReturn = dataResponse
            debugPrint(":::::::::::::::::_____::::::::::::::")
            debugPrint(dataResponse)
            debugPrint(":::::::::::::::::_____::::::::::::::")
        } catch {
            debugPrint(error.localizedDescription)
        }
        completion(httpResponseCode,dataReturn)
    }
    task.resume()
}

func evaluateResponse( controller : UIViewController, httpCode : Int)->Bool{
    debugPrint("el valor del statusCode es \(httpCode)")
    switch httpCode {
    case 200...299:
        return true
    default:
        debugPrint("Entro al defult y manda alerta")
        return false
    }
}
