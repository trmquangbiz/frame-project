//
//  LSLocationManager.swift
//  frameproject
//
//  Created by Quang Trinh on 18/11/2022.
//

import Foundation
import CoreLocation
import UIKit

enum LocationServiceState {
    case disabled
    case restricted
    case notDetermined
    case denied
    case once
    case whileUsing
    case always
}
protocol LSLocationManagerDelegate: AnyObject {
    func locationManagerDidFetchCurrentLocation(_ location: CLLocation)
    func locationManagerCannotFetchCurrentLocation()
}
class LSLocationManager: NSObject {
    static let sharedInstance: LSLocationManager = {
        var manager = LSLocationManager()
        manager.locationManager.delegate = manager
        return manager
    }()
    var currentLocation: CLLocation? {
        if let currentLocation = UserDefaults.standard.object(forKey: "currentLocation") as? [String: NSNumber] {
            if let lat = currentLocation["lat"], let long = currentLocation["long"]  {
                return CLLocation.init(latitude: CLLocationDegrees(truncating: lat), longitude: CLLocationDegrees(truncating: long))
                
            }
        }
        return nil
    }
    
    typealias CustomCompletionHandler = ((CLLocation?, Error?)-> ())
    let queue = DispatchQueue.init(label: "loship.user.customSerialQueueLocationManager")
    var nextLocationListHandlingList: [CustomCompletionHandler] = []
    var currentStatus: CLAuthorizationStatus!
    var isUpdateOncePerTimes: Bool = true
    private var isGotLocationOnce: Bool = false
    var isOnlyGetToReload: Bool = false
    var locationManager: CLLocationManager
    private let concurrentEateryDetailQueue = DispatchQueue(label: "loship.custom.concurrentLocationManagerQueue", attributes: .concurrent)
    private var currentGetDistrictListRequestRemain: Int = 0
    private var currentLoadedDistrictList: [Int:Any] = [:]
    weak var delegate: LSLocationManagerDelegate?
    override init() {
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }
    
    func setDelegate() {
        locationManager.delegate = self
    }
    func startGettingLocation(isForced: Bool = false) {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .restricted, .denied:
                if isForced == true {
                    forceOpenSetting()
                }
                else if let delegate = delegate {
                    delegate.locationManagerCannotFetchCurrentLocation()
                }
                
            case .authorizedAlways, .authorizedWhenInUse:
                isGotLocationOnce = false
                locationManager.startUpdatingLocation()
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
            @unknown default:
                break;
            }
            
        }
        else {
            if isForced == true {
                forceOpenLocationService()
            }
            else if let delegate = delegate {
                delegate.locationManagerCannotFetchCurrentLocation()
            }
            
        }
    }
    

    func isEnableLocationService() -> Bool{
        if CLLocationManager.locationServicesEnabled(), CLLocationManager.authorizationStatus() == .authorizedAlways || CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            return true
        }
        return false
    }
    
    func forceOpenLocationService() {
        // TODO
    }
    func forceOpenSetting() {
        // TODO
        
    }
    
    func getDistrictList(){
        // TODO
    }
    
    func saveCurrentLoadedDistrictList() {
        for key in currentLoadedDistrictList.keys {
            if let data = currentLoadedDistrictList[key] as? [[String:Any]] {
                UserDefaults.standard.setValue(data, forKey: "city\(key)")
            }
            
        }
    }
    
    static func getStatus() -> LocationServiceState {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .restricted:
                return .restricted
            case .denied:
                return .denied
            case .authorizedAlways:
                return .always
            case .authorizedWhenInUse:
                return .whileUsing
            case .notDetermined:
                return .notDetermined
            @unknown default:
                return .notDetermined
            }
        }
        else {
            return .disabled
        }
        
    }
    
    func addHandlingTask(_ task: @escaping CustomCompletionHandler) {
        queue.async {[weak self] in
            if let weakSelf = self {
                weakSelf.nextLocationListHandlingList.append(task)
            }
        }
    }
    
    func handleCurrentTaskList(location: CLLocation?, error: Error?) {
        queue.async {[weak self] in
            if let weakSelf = self, weakSelf.nextLocationListHandlingList.count > 0 {
                for handling in weakSelf.nextLocationListHandlingList {
                    DispatchQueue.main.async {
                        handling(location, error)
                    }
                    
                }
                weakSelf.nextLocationListHandlingList.removeAll()
            }
            
        }
    }
}

extension LSLocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.count > 0 {
            var canUseLocation = true
            if isUpdateOncePerTimes == true && isGotLocationOnce == true {
                canUseLocation = false
            }
            locationManager.stopUpdatingLocation()
            isGotLocationOnce = true
            Debugger.debug {
                return locations.debugDescription
            }
            
            let location = locations[0]
            let lat = location.coordinate.latitude
            let long = location.coordinate.longitude
            let currentLocationInfo: [String:NSNumber] = ["lat":lat as NSNumber,
                                                          "long": long as NSNumber]
            UserDefaults.standard.set(currentLocationInfo, forKey: "currentLocation")
            if let delegate = delegate, canUseLocation == true {
                delegate.locationManagerDidFetchCurrentLocation(location)
            }
            handleCurrentTaskList(location: location, error: nil)
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        handleCurrentTaskList(location: nil, error: error)
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            if isOnlyGetToReload == false {
                locationManager.startUpdatingLocation()
            }
            
        default:
            break;
        }
    }
}
