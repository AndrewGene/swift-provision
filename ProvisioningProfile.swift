//
//  ProvisioningProfile.swift
//  Mapsv2
//
//  Created by Andrew Goodwin on 6/28/16.
//  Copyright © 2016 Conway Corporation. All rights reserved.
//

import Foundation

class ProvisioningProfile: NSObject{
    
    var appName          = ""
    var appIdPrefix      = ""
    var creationDate     = Date()
    var expirationDate   = Date()
    var isDebug          = false
    var appId            = ""
    var teamId           = ""
    var teamName         = ""
    var name             = ""
    var ttl              = 0 //time to live
    var certificateNames = [String]()
    
    static let shared    = ProvisioningProfile()
    
    private override init() { }
}
