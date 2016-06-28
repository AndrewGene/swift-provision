//
//  ProvisioningProfileParser.swift
//  Mapsv2
//
//  Created by Andrew Goodwin on 6/28/16.
//  Copyright © 2016 Conway Corporation. All rights reserved.
//

import Foundation

class ProvisioningProfileParser: NSObject{
    
    private var successfulProvisioningProfileParseClosure: (() -> Void)? = nil
    
    init(data:NSData, success:(() -> Void)){
        super.init()
        self.successfulProvisioningProfileParseClosure = success
        
        let dataString = NSString(data: data, encoding: NSISOLatin1StringEncoding)
        
        let scanner = NSScanner(string: dataString! as String)
        
        var ok = scanner.scanUpToString("<plist", intoString: nil)
        if ok{
            var plistString:NSString? = ""
            ok = scanner.scanUpToString("</plist>", intoString: &plistString)
            if ok{
                plistString = (plistString! as String) + "</plist>"
                //print(plistString)
                let plistData = plistString?.dataUsingEncoding(NSISOLatin1StringEncoding)
                do{
                    let mobileProvision = try NSPropertyListSerialization.propertyListWithData(plistData!, options: .Immutable, format: nil)
                    ProvisioningProfile.sharedProfile.appName = mobileProvision.objectForKey("AppIDName") as! String
                    ProvisioningProfile.sharedProfile.creationDate = mobileProvision.objectForKey("CreationDate") as! NSDate
                    ProvisioningProfile.sharedProfile.expirationDate = mobileProvision.objectForKey("ExpirationDate") as! NSDate
                    let entitlements = mobileProvision.objectForKey("Entitlements") as! NSDictionary
                    if let debug = entitlements.objectForKey("get-task-allow") as? Bool{
                        ProvisioningProfile.sharedProfile.isDebug = debug
                    }
                    ProvisioningProfile.sharedProfile.appId = entitlements.objectForKey("application-identifier") as! String
                    ProvisioningProfile.sharedProfile.teamId = entitlements.objectForKey("com.apple.developer.team-identifier") as! String
                    ProvisioningProfile.sharedProfile.teamName = mobileProvision.objectForKey("TeamName") as! String
                    ProvisioningProfile.sharedProfile.ttl = mobileProvision.objectForKey("TimeToLive") as! Int
                    ProvisioningProfile.sharedProfile.name = mobileProvision.objectForKey("Name") as! String
                    successfulProvisioningProfileParseClosure!()
                }
                catch{
                    
                }
                
            }
        }
    }
}