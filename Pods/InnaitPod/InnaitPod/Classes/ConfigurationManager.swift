//
//  ConfigurationManager.swift
//  PrecisionInnaltKey
//
//  Created by Srinivasan T on 25/08/22.
//

import Foundation
public final class ConfigurationManager: NSObject {
    public func setConfig(url:String,projectId:String,rpId:String) {
        let config = [
            "projectId" : projectId,
            "rpId" : rpId,
            "url" : url,
             ] as NSDictionary
        UserDefaults.standard.setValue(config, forKey: "config")
    }
}
