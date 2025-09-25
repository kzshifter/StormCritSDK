//
//  AppInfoHelper.swift
//  StormCritSDK
//
//  Created by Vadzim Ivanchanka on 9/25/25.
//

import Foundation
    
struct AppInfoHelper {
    
    static func getAppInfo() -> [String: String] {
        let bundle = Bundle.main
        //let processInfo = ProcessInfo.processInfo
        
        return [
            "displayName": bundle.infoDictionary?["CFBundleDisplayName"] as? String ?? "N/A",
            "bundleName": bundle.infoDictionary?["CFBundleName"] as? String ?? "N/A",
            "version": bundle.infoDictionary?["CFBundleShortVersionString"] as? String ?? "N/A",
            "build": bundle.infoDictionary?["CFBundleVersion"] as? String ?? "N/A",
        ]
    }
    
    static func getAppName() -> String {
         if let displayName = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String {
             return displayName
         }
         
         if let bundleName = Bundle.main.infoDictionary?["CFBundleName"] as? String {
             return bundleName
         }
         
         return ProcessInfo.processInfo.processName
     }
}
