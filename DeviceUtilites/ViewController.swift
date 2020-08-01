//
//  ViewController.swift
//  DeviceUtilites
//
//  Created by Nitin on 01/08/20.
//  Copyright © 2020 Nitin. All rights reserved.
//

import UIKit

class ViewController: UIViewController,BatteryEventProtocol {
    
    @IBOutlet weak var storageView: UIView!
    @IBOutlet weak var lblTotalSpace: UILabel!
    @IBOutlet weak var lblUsedSpace: UILabel!
    @IBOutlet weak var batteryMeterView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BatteryEventMonitor.sharedInstance.delegate = self
        getDiskStatus()
        getBatteryStatus()
    }
    
    
    func batteryLevelChanged() {
        getBatteryStatus()
    }
    
    func batteryStatusChanged(){
        print(BatteryEventMonitor.sharedInstance.batteryState)
        let alert = UIAlertController(title: "Battery Status", message: BatteryEventMonitor.sharedInstance.batteryStateInString, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(alertAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func getDiskStatus(){
        let availableInMB = DiskStatus.freeDiskSpace
        let avilableInBytes = DiskStatus.freeDiskSpaceInBytes
        print(DiskStatus.MBFormatter(avilableInBytes)+"MB")
        let totalSpaceInMB = DiskStatus.totalDiskSpace
        let usedSpaceInMB = DiskStatus.usedDiskSpace
        
        lblTotalSpace.text = totalSpaceInMB
        lblUsedSpace.text = usedSpaceInMB
        
        let width = CGFloat(Double(DiskStatus.usedDiskSpaceInBytes)/Double(DiskStatus.totalDiskSpaceInBytes)) * self.storageView.bounds.width
        
        let usedSpaceView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: storageView.frame.height))
        
        usedSpaceView.backgroundColor = .red
        
        storageView.addSubview(usedSpaceView)
        view.layoutIfNeeded() //In contrast, the method layoutIfNeeded is a synchronous call that tells the system you want a layout and redraw of a view and its subviews, and you want it done immediately without waiting for the update cycle. When the call to this method is complete, the layout has already been adjusted and drawn based on all changes that had been noted prior to the method call.


    }

    private func getBatteryStatus(){
        let batteryPercentage = BatteryEventMonitor.sharedInstance.batteryLevel * 100
        
        let totalWidth = self.batteryMeterView.bounds.width

        
        let newWidth = CGFloat((CGFloat(batteryPercentage / 100) * totalWidth))
        let usedBatteryView = UIView(frame: CGRect(x: 0, y: 0, width: newWidth, height: storageView.frame.height))
        usedBatteryView.backgroundColor = .blue
        usedBatteryView.tag = 90
        
        
        
        batteryMeterView.viewWithTag(90)?.removeFromSuperview()
        
        batteryMeterView.addSubview(usedBatteryView)
        
        view.layoutIfNeeded() //In contrast, the method layoutIfNeeded is a synchronous call that tells the system you want a layout and redraw of a view and its subviews, and you want it done immediately without waiting for the update cycle. When the call to this method is complete, the layout has already been adjusted and drawn based on all changes that had been noted prior to the method call.

    }

    @IBAction func testBatteryObserverAction(_ sender: Any) {
    }
}

