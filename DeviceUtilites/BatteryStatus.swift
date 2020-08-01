//
//  BatteryStatus.swift
//  DeviceUtilites
//
//  Created by Nitin on 01/08/20.
//  Copyright © 2020 Nitin. All rights reserved.
//

import Foundation
import UIKit

protocol BatteryEventProtocol {
    func batteryLevelChanged()
    func batteryStatusChanged()
}

class BatteryEventMonitor {
    
    var batteryStateInString = ""
    var delegate : BatteryEventProtocol!
    
    static let sharedInstance = BatteryEventMonitor()
    //this will return negative value in simulator, so test it in real device...
    private init() {
        UIDevice.current.isBatteryMonitoringEnabled = true
        startMonitoring()
    }
    
    //battery level is from 0.0 to 1.0, 0.0 = discharged and 1.0 = fully charged. To change it into percentage 1.0 * 100 = 100%
    var batteryLevel: Float {
        return UIDevice.current.batteryLevel
        
    }
    
    var batteryState: UIDevice.BatteryState { UIDevice.current.batteryState }

    var getSetBatterStateInString : String{
        get {
            return batteryStateInString
        }
        set {
            batteryStateInString = newValue
        }
    }
    
    func startMonitoring() {
        UIDevice.current.isBatteryMonitoringEnabled = true
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.batteryLevelChanged),
            name: UIDevice.batteryLevelDidChangeNotification,
            object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(batteryStateDidChange), name: UIDevice.batteryStateDidChangeNotification, object: nil)
        
    }
    
    @objc func batteryStateDidChange(_ notification: Notification) {
       // case .unknown   //  "The battery state for the device cannot be determined."
        //case .unplugged //  "The device is not plugged into power; the battery is discharging"
        //case .charging  //  "The device is plugged into power and the battery is less than 100% charged."
       // case .full      //   "The device is plugged into power and the battery is 100% charged."

        switch batteryState {
        case .unplugged, .unknown:
            print("not charging")
            getSetBatterStateInString = "not charging"
        case .charging, .full:
            print("charging or full")
            getSetBatterStateInString = "charging or full"

        }
        delegate.batteryStatusChanged()
    }
    
    @objc private func batteryLevelChanged(notification: NSNotification) {
        print("Battery level did change")
        delegate.batteryLevelChanged()

    }
    
    func stopMonitoring() {
        NotificationCenter.default.removeObserver(self,
                                                  name: UIDevice.batteryLevelDidChangeNotification,
                                                  object: nil)
    }
}

