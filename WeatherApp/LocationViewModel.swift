//
//  LocationViewModel.swift
//  WeatherApp
//
//  Created by Karolina Matuszczyk on 05/06/2021.
//

import Foundation
import Combine
import CoreLocation

class LocationViewModel: NSObject, ObservableObject{
  
    @Published var userLatitude: Double
    @Published var userLongitude: Double
  
  private let locationManager = CLLocationManager()
  
  override init() {
    self.userLatitude =  37.32
    self.userLongitude = -122.02
    super.init()
    self.locationManager.delegate = self
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
    self.locationManager.requestWhenInUseAuthorization()
    self.locationManager.startUpdatingLocation()
  }
}

extension LocationViewModel: CLLocationManagerDelegate {
  
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let location = locations.last else { return }
    userLatitude = location.coordinate.latitude
    userLongitude = location.coordinate.longitude
    
  }
}
