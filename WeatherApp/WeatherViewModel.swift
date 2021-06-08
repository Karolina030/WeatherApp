//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Karolina Matuszczyk on 04/05/2021.
//

import Foundation
import Combine
import CoreLocation

class WeatherViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    @Published var woeId: String = ""
    @Published private(set) var model:WeatherModel = WeatherModel(cities: ["523920", "44418", "742676", "868274", "766273", "906057", "565346", "721943", "2459115"])

    

    @Published var currentLocation: CLLocation?
    
    private let locationManager:CLLocationManager
    private let fetcher: MetaWeatherFetcher
    private var cancellables: Set<AnyCancellable>=[]
    private var cancellables2: Set<AnyCancellable>=[]

    
    func fetchWeather(forId woeId: String){
        fetcher.forecast(forId: woeId)
            .sink(receiveCompletion: {completion in
                print(completion)
            }, receiveValue: { value in
                print(value)
            })
            .store(in: &cancellables)
    }
    
    
    override init() {
        locationManager = CLLocationManager()
        
        fetcher = MetaWeatherFetcher()
        locationManager.requestWhenInUseAuthorization()
        print(locationManager.authorizationStatus.rawValue)
        
        super.init()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()

        $woeId
            .map({value in
                print(value.description)
                return value
            })
            .sink(receiveValue: fetchWeather(forId: ))
            .store(in: &cancellables)

    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("location: \(locations)")
        currentLocation = locations.last
    }
    
    
    func refreshIndex(index: Int)-> Int{
        return model.refreshIndex(index: index)
    }
    
    //eksport rekordow z modelu do widoku
    var records: Array<WeatherModel.WeatherRecord>{
        model.records
    }
    
    //funkcja przekazująca intencje odświeżenia konkretnego rekordu
    func refresh(record:WeatherModel.WeatherRecord, i: Int){
//        objectWillChange.send()
        model.refresh(record: record, i: i)
    }

}
