//
//  UIDeviceExtension.swift
//  NetflixClone
//
//  Created by 정유경 on 2020/04/24.
//  Copyright © 2020 Netflex. All rights reserved.
//

import UIKit

extension UIDevice {
    
    var isIPhoneX: Bool {
        return UIScreen.main.nativeBounds.height / UIScreen.main.nativeScale == 812
    }
    var isIPhone: Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }
    
    var safeTop: CGFloat { self.isIPhoneX ? 44 : 20 }
    var safeBottom: CGFloat { self.isIPhoneX ? 34 : 0 }
    
    var identifier: String {
        var sysinfo = utsname()
        uname(&sysinfo)
        let data = Data(bytes: &sysinfo.machine, count: Int(_SYS_NAMELEN))
        let identifier = String(bytes: data, encoding: .ascii)!
        return identifier.trimmingCharacters(in: .controlCharacters)
    }
    
    var modelName: String {
        return modelNameMappingList[identifier] ?? "Unknown"
    }
    
    var simulatorModelName: String {
        let env = ProcessInfo.processInfo.environment
        guard let name = env["SIMULATOR_DEVICE_NAME"] else { return "No Simulator" }
        //    let identifier = env["SIMULATOR_MODEL_IDENTIFIER"]
        //    let runtime = env["SIMULATOR_RUNTIME_VERSION"]
        return name
    }
    
    private var modelNameMappingList: [String: String] {
        return [
            /***************************************************
             iPhone
             ***************************************************/
            "iPhone1,1" : "iPhone",            // (Original)
            "iPhone1,2" : "iPhone",            // (3G)
            "iPhone2,1" : "iPhone",            // (3GS)
            "iPhone3,1" : "iPhone 4",          // (GSM)
            "iPhone3,3" : "iPhone 4",          // (CDMA)
            "iPhone4,1" : "iPhone 4S",         //
            "iPhone5,1" : "iPhone 5",          // (A1428)
            "iPhone5,2" : "iPhone 5",          // (A1429)
            "iPhone5,3" : "iPhone 5c",         // (A1456/A1532)
            "iPhone5,4" : "iPhone 5c",         // (A1507/A1516/A1529)
            "iPhone6,1" : "iPhone 5s",         // (A1433, A1453)
            "iPhone6,2" : "iPhone 5s",         // (A1457, A1518, A1530)
            "iPhone7,1" : "iPhone 6 Plus",     //
            "iPhone7,2" : "iPhone 6",          //
            "iPhone8,1" : "iPhone 6S",         //
            "iPhone8,2" : "iPhone 6S Plus",    //
            "iPhone8,4" : "iPhone SE",         //
            "iPhone9,1" : "iPhone 7",          // (A1660/A1779/A1780)
            "iPhone9,3" : "iPhone 7",          // (A1778)
            "iPhone9,2" : "iPhone 7 Plus",     // (A1661/A1785/A1786)
            "iPhone9,4" : "iPhone 7 Plus",     // (A1784)
            "iPhone10,1": "iPhone 8",          // (A1863/A1906) CDMA
            "iPhone10,4": "iPhone 8",          // (A1905) GSM
            "iPhone10,2": "iPhone 8 Plus",     // (A1864/A1898) CDMA
            "iPhone10,5": "iPhone 8 Plus",     // (A1897) GSM
            "iPhone10,3": "iPhone X",          // (A1865/A1902) CDMA
            "iPhone10,6": "iPhone X",          // (A1901) GSM
            "iPhone11,2": "iPhone XS",         //
            "iPhone11,4": "iPhone XS Max",     //
            "iPhone11,6": "iPhone XS Max",     // China
            "iPhone11,8": "iPhone XR",         //
            "iPhone12,1": "iPhone 11",         //
            "iPhone12,3": "iPhone 11 Pro",     //
            "iPhone12,5": "iPhone 11 Pro Max", //
            
            /***************************************************
             iPad
             ***************************************************/
            "iPad1,1"   : "iPad",              // (Original)
            "iPad2,1"   : "iPad 2",            // (Wi-Fi)
            "iPad2,2"   : "iPad 2",            // (GSM)
            "iPad2,3"   : "iPad 2",            // (CDMA)
            "iPad2,4"   : "iPad 2",            // (Wi-Fi, revised)
            "iPad2,5"   : "iPad mini",         // (Wi-Fi)
            "iPad2,6"   : "iPad mini",         // (A1454)
            "iPad2,7"   : "iPad mini",         // (A1455)
            "iPad3,1"   : "iPad 3",            // (3rd Generation, Wi-Fi)
            "iPad3,2"   : "iPad 3",            // (3rd Generation, Wi-Fi+LTE Verizon)
            "iPad3,3"   : "iPad 3",            // (3rd Generation, Wi-Fi+LTE AT&T)
            "iPad3,4"   : "iPad 4",            // (4th Generation, Wi-Fi)
            "iPad3,5"   : "iPad 4",            // (4th Generation, A1459)
            "iPad3,6"   : "iPad 4",            // (4th Generation, A1460)
            "iPad4,1"   : "iPad Air",          // (Wifi)
            "iPad4,2"   : "iPad Air",          // (Wi-Fi+LTE)
            "iPad4,3"   : "iPad Air",          // (Rev)
            "iPad4,4"   : "iPad mini 2",       // (2nd Generation, Wifi)
            "iPad4,5"   : "iPad mini 2",       // (2nd Generation, Wi-Fi+LTE)
            "iPad4,6"   : "iPad mini 2",       // (2nd Generation, Rev)
            "iPad4,7"   : "iPad mini 3",       // (3rd Generation, Wifi, A1599)
            "iPad4,8"   : "iPad mini 3",       // (3rd Generation, A1600)
            "iPad4,9"   : "iPad mini 3",       // (3rd Generation, A1601)
            "iPad5,1"   : "iPad mini 4",       // (Wi-Fi)
            "iPad5,2"   : "iPad mini 4",       // (Wi-Fi+LTE)
            "iPad5,3"   : "iPad Air 2",        // (Wi-Fi)
            "iPad5,4"   : "iPad Air 2",        // (Wi-Fi+LTE)
            "iPad6,3"   : "iPad Pro (9.7 inch)",  // (Wi-Fi)
            "iPad6,4"   : "iPad Pro (9.7 inch)",  // (Wi-Fi+LTE)
            "iPad6,7"   : "iPad Pro (12.9 inch)", // (Wi-Fi)
            "iPad6,8"   : "iPad Pro (12.9 inch)", // (Wi-Fi+LTE)
            "iPad6,11"  : "iPad 5",               // 5th Gen (Wi-Fi)
            "iPad6,12"  : "iPad 5",               // 5th Gen (Wi-Fi+LTE)
            "iPad7,1"   : "iPad Pro (12.9 inch)", // 2nd Gen
            "iPad7,2"   : "iPad Pro (12.9 inch)", // 2nd Gen
            "iPad7,3"   : "iPad Pro (10.5 inch)", // (A1701)
            "iPad7,4"   : "iPad Pro (10.5 inch)", // (A1709)
            "iPad7,5"   : "iPad 6",               // 6th Gen
            "iPad7,6"   : "iPad 6",               // 6th Gen
            "iPad8,1"   : "iPad Pro (11 inch)",   // 3rd Gen (WiFi)
            "iPad8,2"   : "iPad Pro (11 inch)",   // 3rd Gen (WiFi)
            "iPad8,3"   : "iPad Pro (11 inch)",   // 3rd Gen
            "iPad8,4"   : "iPad Pro (11 inch)",   // 3rd Gen
            "iPad8,5"   : "iPad Pro (12.9 inch)", // 3rd Gen (WiFi)
            "iPad8,6"   : "iPad Pro (12.9 inch)", // 3rd Gen (WiFi)
            "iPad8,7"   : "iPad Pro (12.9 inch)", // 3rd Gen
            "iPad8,8"   : "iPad Pro (12.9 inch)", // 3rd Gen
            "iPad11,1"  : "iPad mini 5",          // 5th Gen (WiFi)
            "iPad11,2"  : "iPad mini 5",          // 5th Gen
            "iPad11,3"  : "iPad Air 3",           // 3rd Gen (WiFi)
            "iPad11,4"  : "iPad Air 3",           // 3rd Gen
            
            /***************************************************
             Apple Watch
             ***************************************************/
            "Watch1,1"  : "Apple Watch 38mm",          //
            "Watch1,2"  : "Apple Watch 38mm",          //
            "Watch2,6"  : "Apple Watch Series 1 38mm", //
            "Watch2,7"  : "Apple Watch Series 1 42mm", //
            "Watch2,3"  : "Apple Watch Series 2 38mm", //
            "Watch2,4"  : "Apple Watch Series 2 42mm", //
            "Watch3,1"  : "Apple Watch Series 3 38mm", // GPS+Cellular
            "Watch3,2"  : "Apple Watch Series 3 42mm", // GPS+Cellular
            "Watch3,3"  : "Apple Watch Series 3 38mm", // GPS
            "Watch3,4"  : "Apple Watch Series 3 42mm", // GPS
            "Watch4,1"  : "Apple Watch Series 4 40mm", // GPS
            "Watch4,2"  : "Apple Watch Series 4 44mm", // GPS
            "Watch4,3"  : "Apple Watch Series 4 40mm", // GPS+Cellular
            "Watch4,4"  : "Apple Watch Series 4 44mm", // GPS+Cellular
            "Watch5,1"  : "Apple Watch Series 5 40mm", // GPS
            "Watch5,2"  : "Apple Watch Series 5 44mm", // GPS
            "Watch5,3"  : "Apple Watch Series 5 40mm", // GPS+Cellular
            "Watch5,4"  : "Apple Watch Series 5 44mm", // GPS+Cellular
            
            /***************************************************
             iPod
             ***************************************************/
            "iPod1,1"   : "iPod Touch",        // Original
            "iPod2,1"   : "iPod Touch 2",      // 2nd Gen
            "iPod3,1"   : "iPod Touch 3",      // 3rd Gen
            "iPod4,1"   : "iPod Touch 4",      // 4th Gen
            "iPod5,1"   : "iPod Touch 5",      // 5th Gen
            "iPod7,1"   : "iPod Touch 6",      // 6th Gen
            "iPod9,1"   : "iPod Touch 7",      // 7th Gen
            
            /***************************************************
             Apple TV
             ***************************************************/
            "AppleTV2,1" : "Apple TV 2",    // 2nd Gen (A1378)
            "AppleTV3,1" : "Apple TV 3",    // 3rd Gen (A1427)
            "AppleTV3,2" : "Apple TV 3",    // 3rd Gen (A1469)
            "AppleTV5,3" : "Apple TV 4",    // 4th Gen (A1625)
            "AppleTV6,2" : "Apple TV 4K",   // (A1842)
            
            /***************************************************
             HomePod
             ***************************************************/
            "AudioAccessory1,1": "HomePod",
            
            /***************************************************
             AirPods
             ***************************************************/
            "AirPods1,1": "AirPods",     // 1st Gen
            "AirPods2,1": "AirPods 2",   // 2nd Gen
            
            /***************************************************
             Simulator
             ***************************************************/
            "i386"      : "Simulator",         // 32 bit
            "x86_64"    : "Simulator",         // 64 bit
        ]
    }
}

