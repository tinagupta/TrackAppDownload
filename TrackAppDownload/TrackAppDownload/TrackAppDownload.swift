//
//  TrackDownloadManager.swift
//  TrackDownloadManager
//
//  Created by Tina on 17/11/20.
//  Copyright © 2020 iTechnoLabs. All rights reserved.
//

import Foundation
import UIKit

public class TrackAppDownload {
    public static let sharedManager = TrackAppDownload()
    
    private init(){
    }
    
    public func logDownload(){
        let bundleId = Bundle.main.bundleIdentifier ?? "BundleId"
        let appLaunchKey = bundleId+"AppLaunched"
        let isAppLaunched = UserDefaults.standard.bool(forKey: appLaunchKey)
        if !isAppLaunched{
            self.updateDownloadOnServer()
            UserDefaults.standard.set(true, forKey: appLaunchKey)
            UserDefaults.standard.synchronize()
        }
    }
    
    private func updateDownloadOnServer(){
        let device = UIDevice.init()
        let bundleId = Bundle.main.bundleIdentifier ?? "Default Bundle ID"
        let deviceId = device.identifierForVendor
        let modelNumber = device.model
        let iosVersion = device.systemVersion
        let appVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
        let buildString = "Version: \(appVersion ?? "").\(build ?? "")"
        let ipAddress = device.ipAddress() ?? "Default IP"
    }

    private func uploadInfoOnServer(){
        let Url = String(format: "http://10.10.10.53:8080/sahambl/rest/sahamblsrv/userlogin")
            guard let serviceUrl = URL(string: Url) else { return }
            let parameters: [String: Any] = [
                "request": [
                        "xusercode" : "YOUR USERCODE HERE",
                        "xpassword": "YOUR PASSWORD HERE"
                ]
            ]
            var request = URLRequest(url: serviceUrl)
            request.httpMethod = "POST"
            request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
            guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
                return
            }
            request.httpBody = httpBody
            request.timeoutInterval = 20
            let session = URLSession.shared
            session.dataTask(with: request) { (data, response, error) in
                if let response = response {
                    print(response)
                }
                if let data = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: [])
                        print(json)
                    } catch {
                        print(error)
                    }
                }
            }.resume()
        }
    }
