//
//  RegisterManager.swift
//  PrecisionInnalTKey
//
//  Created by Srinivasan T on 03/08/22.
//

import Foundation
import UIKit
import os
import AuthenticationServices

let oAuth = oAuthManager()

public final class RegisterManager: NSObject {
    
   
    
    public func getRegisterRequest(anchor:ASPresentationAnchor,userId :String,userRef:String,description:String) {
        let config = UserDefaults.standard.object(forKey: "config") as! NSDictionary
        let mainurl = config["url"] as! String
        let rpId = config["rpId"] as! String
        let projectId = config["projectId"] as! String

//        let urls = "https://ikmelio.innaitkey.com/api/fido/getAssertionRequest?projectId=innait&rpId=ikmelio.innaitkey.com&externalRef=muser01"
        let urls = "\(mainurl)getRegisterRequest? description=\(description)&projectId=\(projectId)&rpId=\(rpId)&userId=\(userId)&userRef=\(userRef)"
        RequestCall.getMethod( url: urls, completion:  { statusDict in
            DispatchQueue.main.async {
                let regValue = UserDefaults.standard.object(forKey: "getReg") as! NSDictionary
                let public_key = regValue["publicKey"] as! NSDictionary
                let rp = public_key["rp"] as! NSDictionary
                let user = public_key["user"] as! NSDictionary

                oAuth.signUpWith(userName: user["name"] as! String, relyingParty: rp["id"] as! String, challengeStr: public_key["challenge"] as! String, anchor: anchor)
            }
                
                        })
    }
   
    public  func RegisterListApiCall(completion completionBlock: @escaping (NSDictionary) -> Void) {
        let config = UserDefaults.standard.object(forKey: "config") as! NSDictionary
        let mainurl = config["url"] as! String
        let projectId = config["projectId"] as! String

        let regValue = UserDefaults.standard.object(forKey: "response") as! NSDictionary
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

        RequestCall.requestCall(parameters,bodyContent: true, url1: "\(mainurl)register?projectId=\(projectId)", completion: {
            Result,statusDict in
            DispatchQueue.main.async {
                        completionBlock(statusDict)
                      }
                  })
              }
}
