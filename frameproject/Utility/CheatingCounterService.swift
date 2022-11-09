//
//  CheatingCounterService.swift
//  frameproject
//
//  Created by Quang Trinh on 24/10/2022.
//

import Foundation

import Foundation
import CoreLocation
import UIKit
class TrackingData: Encodable {
    var deviceId: String
    var motionSensor: [SensorResult]
    var duration: Int64
    var appName: String = "loship_merchant"
    var serverTime: Int64
    var appBuildNumber: Int?
    var deviceLat: Double
    var deviceLng: Double
    var isIOSJailBroken: Bool
    var device: String
    var platform: String
    var deviceName: String
    
    init (deviceId: String, motionSensor: [SensorResult], duration: Int64, serverTime: Int64, deviceLocation: DeviceLocation) {
        self.deviceId = deviceId
        self.motionSensor = motionSensor
        self.duration = duration
        self.serverTime = serverTime
        if let appBuildNumberStr = Utils.getBuildNumber(), let appBuildNumber = Int.init(appBuildNumberStr) {
            self.appBuildNumber = appBuildNumber
        }
        deviceLat = deviceLocation.lat
        deviceLng = deviceLocation.lng
        isIOSJailBroken = TrackingData.isJailbroken()
        device = UIDevice.current.modelName
        platform = "\(UIDevice.current.systemName) \(UIDevice.current.systemVersion)"
        deviceName = UIDevice.current.name
    }
    
    static func isJailbroken() -> Bool {
        
        guard let cydiaUrlScheme = NSURL(string: "cydia://package/com.example.package") else { return false }
        if UIApplication.shared.canOpenURL(cydiaUrlScheme as URL) {
            return true
        }
        
        #if arch(i386) || arch(x86_64)
            // This is a Simulator not an idevice
            return false
        #endif
        
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: "/Applications/Cydia.app") ||
            fileManager.fileExists(atPath: "/Library/MobileSubstrate/MobileSubstrate.dylib") ||
            fileManager.fileExists(atPath: "/bin/bash") ||
            fileManager.fileExists(atPath: "/usr/sbin/sshd") ||
            fileManager.fileExists(atPath: "/etc/apt") ||
            fileManager.fileExists(atPath: "/usr/bin/ssh") ||
            fileManager.fileExists(atPath: "/private/var/lib/apt") {
            return true
        }
        
        if canOpen(path: "/Applications/Cydia.app") ||
            canOpen(path: "/Library/MobileSubstrate/MobileSubstrate.dylib") ||
            canOpen(path: "/bin/bash") ||
            canOpen(path: "/usr/sbin/sshd") ||
            canOpen(path: "/etc/apt") ||
            canOpen(path: "/usr/bin/ssh") {
            return true
        }
        
        let path = "/private/" + NSUUID().uuidString
        do {
            try "anyString".write(toFile: path, atomically: true, encoding: String.Encoding.utf8)
            try fileManager.removeItem(atPath: path)
            return true
        } catch {
            return false
        }
    }
    
    static func canOpen(path: String) -> Bool {
        let file = fopen(path, "r")
        guard file != nil else { return false }
        fclose(file)
        return true
    }
    
}
class SensorResult: Encodable {
    var x: Double
    var y: Double
    var z: Double
    
    init (x: Double, y: Double, z: Double) {
        self.x = x
        self.y = y
        self.z = z
    }
}
class CheatingCounterService {
    private var currentSensor: [SensorResult] = []
    private let queue = DispatchQueue.init(label: "loship.custom.serialCheatingCounter")
    private let maximumNumberInQueue: Int = 10
    private var lastLocation: CLLocationCoordinate2D?
    private var startTime: Date!
    private var endTime: Date!
    private let locationManager: LSLocationManager
    private var lastUpdateSensor: Date?
    static let shared: CheatingCounterService = {
        var manager = CheatingCounterService()
        return manager
    }()
    init () {
        locationManager = LSLocationManager()
        locationManager.delegate = self
    }
    func getUID() -> String {
        return DeviceUID.uid()
    }
    func getMotionSensor() {
        var canGet: Bool = true
        let date = Date()
        if let lastUpdateSensor = lastUpdateSensor, date.timeIntervalSince(lastUpdateSensor) < 0.1 {
            canGet = false
        }
        if canGet {
            print ("Get Motion Sensor")
            lastUpdateSensor = date
            let motionKit = MotionKit()
            motionKit.getAccelerationAtCurrentInstant {[weak self] (x, y, z) in
                if let weakSelf = self {
                    weakSelf.queue.async {[weak self] in
                        if let weakSelf = self {
                            print("Got motion at coordinate (\(x), \(y), \(z)")
                            let result = SensorResult.init(x: x, y: y, z: z)
                            weakSelf.enqueue(result)
                        }
                    }
                }
            }
        }
        
    }
    
    func getDuration() -> Int64 {
        return NSNumber(value: (endTime.timeIntervalSince(startTime))).int64Value
    }
    
    private func enqueue(_ value: SensorResult) {
        if currentSensor.count >= maximumNumberInQueue {
            dequeue()
            enqueue(value)
        }
        if currentSensor.count < maximumNumberInQueue {
            currentSensor.append(value)
        }
    }
    
    private func dequeue() {
        if currentSensor.isEmpty == false {
            currentSensor.removeFirst()
        }
    }
    
    private func getCurrentSensorResults() -> [SensorResult] {
        return currentSensor
    }
    private func setStartTime(_ time: Date) {
        startTime = time
    }
    private func setEndTime(_ time: Date) {
        endTime = time
    }
    
    func submitData(with deviceLocation: DeviceLocation) -> String {
        let serverTimeStamp = getServerTimeStampToSubmit()
        let sensorResults = currentSensor
        let duration = getDuration()
        let uid = getUID()
        
        let trackingData = TrackingData.init(deviceId: uid, motionSensor: sensorResults, duration: duration, serverTime: serverTimeStamp, deviceLocation: deviceLocation)
        if let json = trackingData.asDictionary() {
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: json, options: [])
                let jsonString = String(data: jsonData, encoding: .utf8)!
                if let encryptedStr = Utils.encryptTrackingData(jsonString) {
                    return encryptedStr
                }
                else {
                    return ""
                }
            } catch {
                
            }
        }
        
        return ""
        
    }
    
    func resetTime() {
        setStartTime(Date())
    }
    
    func markEndTime() {
        setEndTime(Date())
    }
    
    private func getLatestServerTimeDiff() -> Double {
        if let latestDiff = UserDefaults.standard.object(forKey: Constant.kLatestServerTimeDiff) as? Double {
            return latestDiff
        }
        return 0
    }
    
    
    
    private func getServerTimeToSubmit() -> Date {
        return Date().addingTimeInterval(-getLatestServerTimeDiff())
    }
    
    private func getServerTimeStampToSubmit() -> Int64 {
        return NSNumber(value: (getServerTimeToSubmit().timeIntervalSince1970)).int64Value
    }
    
    func saveServerTimeDiff(from date: Date) {
        DispatchQueue.main.async {
            var diff: Double = 0
            diff = Date().timeIntervalSince(date)
            let userDefaults = UserDefaults.standard
            userDefaults.set(diff, forKey: Constant.kLatestServerTimeDiff)
        }
        
    }
    
    class func getTrackingDataOnCheckIn() -> String {
        var encryptedTrackingData: String = ""
        var trackingParam: [String:AnyObject] = [:]
        let uId = DeviceUID.uid()
        var location: [String: AnyObject] = [:]
        if let currentLocation =  LMLocationManager.sharedInstance.currentLocation {
            location["deviceLat"] = currentLocation.coordinate.latitude as AnyObject
            location["deviceLng"] = currentLocation.coordinate.longitude as AnyObject
        }
        do {
            trackingParam["geoLocation"] = location as AnyObject
            trackingParam["deviceId"] = uId as AnyObject
            let jsonData = try JSONSerialization.data(withJSONObject: trackingParam, options: [])
            if let jsonString = String.init(data: jsonData, encoding: .utf8), let hashStr = Utils.encryptTrackingData(jsonString) {
                encryptedTrackingData = hashStr
            }
        } catch let error {
            print("Failed to make data", error)
        }
        
        return encryptedTrackingData
    
    }
    
}

extension CheatingCounterService: LSLocationManagerDelegate {
    func locationManagerCannotFetchCurrentLocation() {
        
    }
    
    func locationManagerGetToReload() {
        
    }
    
    func locationManagerDidFetchCurrentLocation(_ location: CLLocation) {
        // submit data here
        
    }
    
    
}

class DeviceLocation: Encodable {
    var lat: Double
    var lng: Double
    init(lat: Double, lng: Double) {
        self.lat = lat
        self.lng = lng
    }
}
