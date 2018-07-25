//
//  ProvisioningProfileParser.swift
//  Mapsv2
//
//  Created by Andrew Goodwin on 6/28/16.
//  Copyright © 2016 Conway Corporation. All rights reserved.
//

import Foundation

class ProvisioningProfileParser: NSObject{
    
    init(success:(() -> ())?){
        super.init()
        
        DispatchQueue.global().async {
            guard let url = Bundle.main.url(forResource: "embedded", withExtension: "mobileprovision"), let data = try? Data(contentsOf: url), let string = String(data: data, encoding: String.Encoding.isoLatin1) else {
                ProvisioningProfile.shared.isDebug = true
                DispatchQueue.main.async {
                    success?()
                }
                return
            }

            let scanner = Scanner(string: string)
            if scanner.scanUpTo("<plist", into: nil) {
                var plistString:NSString? = ""
                if scanner.scanUpTo("</plist>", into: &plistString) {
                    plistString = (plistString! as String) + "</plist>" as NSString
                    
                    if let plistData = plistString?.data(using: String.Encoding.isoLatin1.rawValue) {
                        if let mobileProvision = try? PropertyListSerialization.propertyList(from: plistData, options: [], format: nil) as! [String:Any] {
                            ProvisioningProfile.shared.appName        = mobileProvision["AppIDName"] as! String
                            ProvisioningProfile.shared.creationDate   = mobileProvision["CreationDate"] as! Date
                            ProvisioningProfile.shared.expirationDate = mobileProvision["ExpirationDate"] as! Date
                            let entitlements                                 = mobileProvision["Entitlements"] as! [String:Any]
                            if let debug = entitlements["get-task-allow"] as? Bool{
                                ProvisioningProfile.shared.isDebug    = debug
                            }
                            
                            ProvisioningProfile.shared.appId          = entitlements["application-identifier"] as! String
                            ProvisioningProfile.shared.teamId         = entitlements["com.apple.developer.team-identifier"] as! String
                            ProvisioningProfile.shared.teamName       = mobileProvision["TeamName"] as! String
                            ProvisioningProfile.shared.ttl            = mobileProvision["TimeToLive"] as! Int
                            ProvisioningProfile.shared.name           = mobileProvision["Name"] as! String
                            
                            
                            if let certData = mobileProvision["DeveloperCertificates"] as? [Data] {
                                var certificateNames = [String]()
                                for data in certData {
                                    let certificate:SecCertificate = SecCertificateCreateWithData(nil, data as CFData)!
                                    let description:CFString       = SecCertificateCopySubjectSummary(certificate)!
                                    certificateNames.append(description as String)
                                }
                                ProvisioningProfile.shared.certificateNames = certificateNames
                            }
                            
                            DispatchQueue.main.async {
                                success?()
                            }
                            
                        }
                    }
                }
            }
        }
    }
}
