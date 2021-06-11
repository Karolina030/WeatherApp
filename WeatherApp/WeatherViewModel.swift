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
    var cities = ["523920", "44418", "742676", "868274", "766273", "906057", "565346", "721943", "2459115"]
    @Published private(set) var model = WeatherModel()

    @Published var currentLocation: CLLocation?
    @Published var closestCity: String?;

    
    private let locationManager:CLLocationManager
    private let fetcher = MetaWeatherFetcher()
    private var cancellables: Set<AnyCancellable>=[]
    private var cancellables2: Set<AnyCancellable>=[]
    private var cancellables3: Set<AnyCancellable>=[]


    //eksport rekordow z modelu do widoku
    var records: Array<WeatherModel.WeatherRecord>{
        model.records
    }

    
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
        
        //fetcher = MetaWeatherFetcher()
        locationManager.requestWhenInUseAuthorization()
        print(locationManager.authorizationStatus.rawValue)
        
        super.init()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        
        for city in cities {
             fetcher.forecast(forId: city)
                 .sink(receiveCompletion: { _ in},
                       receiveValue: { value in
                        self.model.records.append(WeatherModel.WeatherRecord(response: value))
                 })
                 .store(in: &cancellables)
         }
        

    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("location: \(locations)")
        currentLocation = locations.last
        currentCity()
    }
    
    func currentCity(){
        if let location = self.currentLocation{
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(location, completionHandler: {
                (placemarks, error) in
                    if error == nil {
                        let firstLocation = placemarks?[0]
                        self.closestCity = firstLocation!.locality
                        }
                
                    })

            let lat = String(currentLocation!.coordinate.latitude)
            let lon = String(currentLocation!.coordinate.longitude)
            
            fetcher.checkCity(forId: lat, forId: lon)
                .sink(receiveCompletion: {completion in
                print(completion)
            }, receiveValue: { value in
                let woeid = String(value[0].woeid)
                let weatherCityName = value[0].title
                
                self.fetcher.forecast(forId: woeid)
                    .sink(receiveCompletion: { _ in},
                          receiveValue: { value in
                            self.model.records[0] = WeatherModel.WeatherRecord(response: value)
                            self.model.records[0].cityName = String(self.closestCity!) + " \n("+String(weatherCityName)+")"
                    })
                    .store(in: &self.cancellables3)
                
                
            }).store(in: &cancellables2)
            
        }
    }


    
    func refreshIndex(index: Int)-> Int{
        return model.refreshIndex(index: index)
    }

    
    //funkcja przekazująca intencje odświeżenia konkretnego rekordu
    func refresh(record:WeatherModel.WeatherRecord){
        objectWillChange.send()
        model.refresh(record: record)
    }

}
