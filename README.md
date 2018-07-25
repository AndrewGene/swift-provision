# swift-provision
Simple files that provide the ability to read the embedded provisioning profile in an iOS app
###### This code is just enough to meet my needs.  You can easily make a pull request and edit it to find more values from the profile

**Usage**
```swift
  let _ = ProvisioningProfileParser(success: {
      //the parser does it's work in a background thread; this callback is now on the main UI thread
      //ProvisioningProfile.sharedProfile is a singleton
      print(ProvisioningProfile.sharedProfile.isDebug)
  })
```

**Current Values being pulled**
- Name
- AppIDName
- CreationDate
- ExpirationDate
- Entitlements
- get-task-allow (only present and possibly true if app is running on a device; **if true, app is in debug**)
- application-identifier
- com.apple.developer.team-identifier
- TeamName
- TimeToLive (I believe this is days before expiration)
- CertificateNames (Names of all certificates used to sign the build)

