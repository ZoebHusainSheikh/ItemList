//
//  NetworkHttpClient.swift
//  ItemList
//
//  Created by Zoeb on 08/11/21.
//

import UIKit
import Foundation

typealias CompletionHandler = (_ success: Bool, _ response: Any?) -> Void

final class NetworkHttpClient: NSObject {
    private enum Constants {
        static let getMethod:String = "GET"
    }
    
    typealias successBlock = (_ response: Data) -> Void
    typealias failureBlock = (_ response: Error?) -> Void
    
    static let sharedInstance = NetworkHttpClient()
    
    func performAPICall(_ strURL : String?, method: String? = Constants.getMethod, parameters : Dictionary<String, Any>? = nil, success:@escaping successBlock, failure:@escaping failureBlock){
        if let urlPath:String = strURL {
            
            guard let url = URL(string: urlPath) else {return}
            var request = URLRequest.initWithURL(url: url, method: method, parameters: nil)
            
            if let parameters = parameters {
                debugPrint("parameters: " + parameters.description)
                 var  jsonData = NSData()
                do {
                    jsonData = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) as NSData
                    // you can now cast it with the right type
                } catch {
                    print(error.localizedDescription)
                }
                request.setValue("\(jsonData.length)", forHTTPHeaderField: "Content-Length")
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.httpBody = jsonData as Data
            }
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                self.parseResponse(success: success, failure: failure, data: data, response: response, error: error)
            }
            task.resume()
        }
    }
}

private extension NetworkHttpClient {
    
    func parseResponse(success: successBlock, failure: failureBlock, data: Data?, response: URLResponse?, error: Error?) {
        guard let dataResponse = data,
              error == nil else {
            debugPrint(error?.localizedDescription ?? "Response Error")
            failure(error)
            AlertViewController.sharedInstance.alertWindow(message: error?.localizedDescription ?? AlertViewController.kSomethingWentWrongMessage)
            return
        }
        
        success(dataResponse)
    }
    
}

extension URLRequest {
    static func initWithURL(url: URL, method: String? , parameters:Dictionary<String, Any>?) -> URLRequest {
        var request = URLRequest(url:url)
        request.httpMethod = method
        return request
    }
}
