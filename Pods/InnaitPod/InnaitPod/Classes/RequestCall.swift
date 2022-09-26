//
//  RequestCall.swift
//  HCL
//
//  Created by Srinivasan T on 26/07/19.
//  Copyright © 2019 Srinivasan T. All rights reserved.
//

import Foundation
import UIKit
import SystemConfiguration



public final class RequestCall: NSObject {
    
    

    public class func isValidEmail(emailStr:String) -> Bool {
           let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

           let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
           return emailPred.evaluate(with: emailStr)
       }
    
   
    class func isConnectedToNetwork() -> Bool {

           var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
           zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
           zeroAddress.sin_family = sa_family_t(AF_INET)

           let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
               $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                   SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
               }
           }

           var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
           if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
               return false
           }

           /* Only Working for WIFI
           let isReachable = flags == .reachable
           let needsConnection = flags == .connectionRequired

           return isReachable && !needsConnection
           */

           // Working for Cellular and WIFI
           let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
           let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
           let ret = (isReachable && !needsConnection)

           return ret

       }
    
    public class  func getMethod(url:String, completion completionBlock: @escaping (NSDictionary) -> Void) {
        if isConnectedToNetwork(){
        let projectId = UserDefaults.standard.string(forKey: "projectId")
        let rpId = UserDefaults.standard.string(forKey: "rpId")

        guard let url = URL(string: "\(url)")
                                else {
                print("Error: cannot create URL")
                let statusDict = [
                       "status": "2",
                       "message": "Error: cannot create URL",
                       ] as NSDictionary
                completionBlock(statusDict)
                return
            }
//        guard let url = URL(string: "https://ikmelio.innaitkey.com/api/fido/getRegisterRequest?description=Welcome%20Precision&projectId=innait&rpId=ikmelio.innaitkey.com&userId=6304706fc7cefa0007621258&userRef=muser01")
//                            else {
//            print("Error: cannot create URL")
//            return
//        }
            // Create the url request
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard error == nil else {
                    print("Error: error calling GET")
                    print(error!)
                    return
                }
                guard let data = data else {
                    print("Error: Did not receive data")
                    return
                }
                guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
                    print("Error: HTTP request failed")
                    let statusDict = [
                           "status": "2",
                           "message": "Error: HTTP request failed",
                           ] as NSDictionary
                    completionBlock(statusDict)

                    return
                }
                do {
                    if let json =  try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSDictionary {
                        UserDefaults.standard.setValue(json, forKey: "getReg")
                        let statusDict = [
                               "status": "1",
                               "message": "",
                               ] as NSDictionary
                        completionBlock(statusDict)
                    }
                    guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                        print("Error: Cannot convert data to JSON object")
                        return
                    }
                    guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted) else {
                        print("Error: Cannot convert JSON object to Pretty JSON data")
                        return
                    }
                    guard let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) else {
                        print("Error: Could print JSON in String")
                        return
                    }
                    
                    print(prettyPrintedJson)
                    UserDefaults.standard.setValue(prettyPrintedJson, forKey: "regStr")

                } catch {
                    print("Error: Trying to convert JSON data to string")
                    return
                }
            }.resume()
        }else {
            let statusDict = [
                   "status": "2",
                   "message": "Error: No Network connectivity",
                   ] as NSDictionary
            completionBlock(statusDict)
        }
    }
  

    
    public class func requestCall(_ parameters: NSDictionary,bodyContent:Bool, url1: String, completion completionBlock: @escaping (NSDictionary,NSDictionary) -> Void) {
        if isConnectedToNetwork(){
            // let parameters = ["id": 13, "name": "jack"] as [String : Any]
        
            //create the url with URL
            let mainUrl =  url1
            let url = URL(string: mainUrl)!
        
            //create the session object
            let session = URLSession.shared
        
            //now create the URLRequest object using the url object
            var request = URLRequest(url: url)
            request.httpMethod = "POST"  //set http method as POST
            if bodyContent == true {
                let jsonData = try! JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions.prettyPrinted)
                let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
                print(jsonString)
                let data = jsonString.data(using: .utf8)
                request.httpBody = data
            }
         //   request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            //description=WelcomePrecision&projectId=ikuat&rpId=ikdemo.innaitkey.com&userId=6304706fc7cefa0007621258&userRef=muser01
            do{
                        let task = session.dataTask(with: request as URLRequest as URLRequest, completionHandler: {(data, response, error) in
                            var statusCode = Int()
                            if let response = response {
                                let nsHTTPResponse = response as! HTTPURLResponse
                                statusCode = nsHTTPResponse.statusCode
                            }
                            if let error = error {
                                print ("\(error)")
                                let statusDict = [
                                       "status": "2",
                                       ] as NSDictionary
                                let jsonDict = [
                                    "message": "\(error.localizedDescription)",
                                       ] as NSDictionary
                                completionBlock(jsonDict,statusDict)
                            }
                            if let data = data {
                                do{
                                    if statusCode >= 200 &&  statusCode <= 299 {
                                    if let json =  try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSDictionary {
                                        let statusDict = [
                                               "status": "1",
                                               ] as NSDictionary
                                        completionBlock(json as NSDictionary,statusDict)
                                    }
                                    }else {
                                        if let json =  try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSDictionary {
                                            let statusDict = [
                                                   "status": "2",
                                                   ] as NSDictionary
                                            completionBlock(json as NSDictionary,statusDict)
                                        }

                                    }
//                                    let jsonResponse = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                                }catch _ {
                                    print ("OOps not good JSON formatted response")
                                }
                            }
                        })
                        task.resume()
                    }catch _ {
                        print ("Oops something happened")
                    }
        }else {
            let statusDict = [
                   "status": "2",
                   ] as NSDictionary
            let jsonDict = [
                   "message": "Device is not connected to the Internet",
                   ] as NSDictionary
            completionBlock(jsonDict,statusDict)

        }
    }
}

extension NSDictionary {
    func percentEscaped() -> String {
        return map { (key, value) in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
            }
            .joined(separator: "&")
    }
}

extension Dictionary {
    func percentEscaped() -> String {
        return map { (key, value) in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
            }
            .joined(separator: "&")
    }
}

extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        
        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}

