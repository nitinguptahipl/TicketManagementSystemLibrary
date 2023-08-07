//
//  AppDelegate.swift
//  TicketManagementSystem
//
//  Created by HIPL on 13/07/23.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        getOfflineData(dataOffline: "{\"CUSTOMER_NAME\":\"Nitin Gupta\",\"CUSTOMER_EMAIL\":\"nitinmca18jim@gmail.com\",\"CUSTOMER_PHONE\":\"8303991734\",\"LOCATION_TYPE_ID\":\"\",\"CUSTOMER_ID\":\"77\",\"TOKEN\":\"80efa774431215606c080d974e1f9cab\",\"TICKET_ORG_ID\":\"93\",\"TICKET_LOCATION_ID\":\"66\",\"APPLICATION\":\"I\",\"DEVICE\":\"I\",\"SYSTEM_ID\":\"F\",\"SIGNIN_TYPE\":\"P\",\"REQUEST_TYPE\":\"TKTINCIDENCE\",\"APP_DOMAIN\":\"flosenso.com\", \"Base_Url\":\"https://tessapp.tess360.com/\"}")
        self.window?.makeKeyAndVisible()
        return true
    }

    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    public func getOfflineData(dataOffline:String) {
        let cryptoData = dataOffline.data(using: .utf8)!
        do {
            let decoder = JSONDecoder()
            let serviceResponse = try decoder.decode(TicketData.self, from: cryptoData)
            ticketResp = serviceResponse
        } catch let error as NSError {
            print(error)
        }
        
    }

}

