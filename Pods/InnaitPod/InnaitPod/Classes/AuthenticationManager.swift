//
//  authenticationManager.swift
//  PrecisionInnalTKey
//
//  Created by Srinivasan T on 03/08/22.
//

import Foundation
import UIKit
import os
import AuthenticationServices

let oAuthMan = oAuthManager()


 public final class AuthenticationManager: NSObject {
    
   
     public func getAssertionRequest(externalRef:String,anchor:ASPresentationAnchor) {
         let config = UserDefaults.standard.object(forKey: "config") as! NSDictionary
         let mainurl = config["url"] as! String
         let rpId = config["rpId"] as! String
         let projectId = config["projectId"] as! String
         let parameters = [:] as NSDictionary
         let apiUrl = "\(mainurl)getAssertionRequest?projectId=\(projectId)&rpId=\(rpId)&externalRef=\(externalRef)"
        RequestCall.requestCall(parameters,bodyContent: false , url1: apiUrl , completion: {
            Result,statusDict in
            
            print("Result =\(Result)")
            let publicKey = Result["publicKey"] as! NSDictionary
            let chage = publicKey["challenge"] as! String
            oAuthMan.signInWith(anchor: anchor, relyingParty: rpId, challengeStr: chage)
            //        (UIApplication.shared.delegate as? //AppDelegate)?.accountManager.signInWith(anchor: window)

                  })
    }
    
     public func LogInApiCall(reason:String,title:String,prompt:String,completion completionBlock: @escaping (NSDictionary) -> Void) {
         let config = UserDefaults.standard.object(forKey: "config") as! NSDictionary
         let mainurl = config["url"] as! String
         let projectId = config["projectId"] as! String

         let regValue = UserDefaults.standard.object(forKey: "signResponse") as! NSDictionary
         var json = String()
         do {
                let jsonData = try JSONSerialization.data(withJSONObject: regValue)
                if let jsonStr = String(data: jsonData, encoding: .utf8) {
                    json = jsonStr
                    //print(json)

                }
            } catch {
                print("something went wrong with parsing json")
            }
         let parameters = [
             "publicKeyCredential" : regValue,
         ] as NSDictionary
         print("Rest api json response ==> \(parameters)")
         let apiUrl = "\(mainurl)register?projectId=\(projectId)&reason=\(reason)&title=\(title)&prompt=\(prompt)"
         RequestCall.requestCall(parameters,bodyContent: true, url1: apiUrl, completion: {
             Result,statusDict in
             DispatchQueue.main.async {
                         completionBlock(statusDict)
                       }
                   })
               }
     
     public func getTransactionAssertionRequest(userId:String, userRef:String, externalRef:String, payload:String, hash:String, completion completionBlock: @escaping (NSDictionary) -> Void) {
         let config = UserDefaults.standard.object(forKey: "config") as! NSDictionary
         let mainurl = config["url"] as! String
         let rpId = config["rpId"] as! String
         let projectId = config["projectId"] as! String
         let parameters = [:] as NSDictionary
         let apiUrl = "\(mainurl)getTransactionAssertionRequest?projectId=\(projectId)&rpId=\(rpId)&userId=\(userId)&userRef=\(userRef)&externalRef=\(externalRef)&payload=\(payload)&hash=\(hash)"
        RequestCall.requestCall(parameters,bodyContent: false , url1: apiUrl , completion: {
            Result,statusDict in
            print("Result =\(Result)")
            completionBlock(Result)
                  })
     }
     
     public func getUserToken(tokenId:String, completion completionBlock: @escaping (NSDictionary) -> Void) {
         let config = UserDefaults.standard.object(forKey: "config") as! NSDictionary
         let mainurl = config["url"] as! String
         let projectId = config["projectId"] as! String
         let parameters = [:] as NSDictionary
         let apiUrl = "\(mainurl)getUserToken?projectId=\(projectId)&tokenId=\(tokenId)"
        RequestCall.requestCall(parameters,bodyContent: false , url1: apiUrl , completion: {
            Result,statusDict in
            print("Result =\(Result)")
            completionBlock(Result)
                  })
     }

}
