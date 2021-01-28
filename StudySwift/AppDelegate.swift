//
//  AppDelegate.swift
//  StudySwift
//
//  Created by Yoon on 2021/1/2.
//

import UIKit
import AVFoundation

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
//        let curl = URL(string: "file://\(NSHomeDirectory())/Documents/morning.mp4")!
//        let path1111 = "file://\(NSHomeDirectory())/Documents/222.mov"
//        let data222 = try? Data.init(contentsOf: curl, options: .dataReadingMapped)
//        try? data222!.write(to: URL.init(string: path1111)!, options: .atomic)
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0) {
//            let curl222 = URL(string: "file://\(NSHomeDirectory())/Documents/222.mp4")!
//            var readHandle: FileHandle = FileHandle.init(forReadingAtPath: curl222.path)!
//            readHandle.seek(toFileOffset: 0)
//            let data = readHandle.readData(ofLength: Int(2 * 1024 * 1024))
//            let path = "file://\(NSHomeDirectory())/Documents/333.mp4"
//            try? data.write(to: URL.init(string: path)!, options: .atomic)
//        }
//        let manage = ReverseManager.defaultManager
//        manage.trimWithAssetPath(curl.path, startPoint: CMTime.zero) { (paths) in
//            let pefa = manage.calculatePieceData(Double(3 * 1024 * 1024), files: paths)
//            let pd = manage.checkOfAddToPreviousPiece(pefa, minOffset: Double(2 * 1024 * 1024))
//            let pah = manage.syntheticVideo(pd, outputPath: "\(NSHomeDirectory())/Documents/")
//            for i in pah {
//                print(i)
//            }
//        }
        
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


}

