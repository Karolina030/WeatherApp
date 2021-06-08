//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by Karolina Matuszczyk on 04/05/2021.
//

import Foundation
import Combine
import CoreLocation
import MapKit
import SwiftUI



private let defaultIcon = "🌤"
private let iconMap = [
    "Thunderstorm":"🌩",
    "Snow":"❄️",
    "Clear":"☀️",
    "Heavy Cloud":"☁️",
    "Light Cloud":"🌤",
    "Sleet":"🌨",
    "Hail":"🌨",
    "Heavy Rain":"⛈",
    "Light Rain":"🌦",
    "Showers":"🌦",
    
]

struct WeatherModel{
    
    var records: Array<WeatherRecord> = []
    private let fetcher: MetaWeatherFetcher = MetaWeatherFetcher()
    private let response: MetaWeatherResponse? = nil
    private let response2 = [MetaWeatherResponseLocationElement]()

    @ObservedObject var locationViewModel = LocationViewModel()
    
    init(cities: Array<String>){
        
        records = Array<WeatherRecord>()
        
        for n in 0...(cities.count-1) {
            
            if n==0{
                guard let url2 = URL(string: "https://www.metaweather.com/api/location/search/?lattlong=\(locationViewModel.userLatitude),\(locationViewModel.userLongitude)") else{
                    print("invalid URL")
                    return
                }
                var result2: [MetaWeatherResponseLocationElement]?
                let group2 = DispatchGroup()
                group2.enter()
                URLSession.shared.dataTask(with: url2, completionHandler:  { data2, response2, error in
                    do {
                        result2 = try JSONDecoder().decode([MetaWeatherResponseLocationElement].self, from: data2!)
                        group2.leave()
                    }
                    catch{
                        print(error)
                    }
                }).resume()
                group2.wait()

                print(result2![0].woeid)
                
                
                let url = URL(string: "https://www.metaweather.com/api/location/"+String(result2![0].woeid)+"/")
                var result: MetaWeatherResponse?
                let group = DispatchGroup()
                group.enter()
                URLSession.shared.dataTask(with: url!, completionHandler: { data, response, error in
                    do {
                        result = try JSONDecoder().decode(MetaWeatherResponse.self, from: data!)
                        group.leave()
                    }
                    catch{
                        print("Error")
                    }
                }).resume()
                group.wait()
                
                let str = result!.lattLong
                let components = str.components(separatedBy: ",")
                
                self.records.append(WeatherRecord(cityName: result!.title, weatherIcon: "", weatherState: result!.consolidatedWeather[0].weatherStateName, temperature: Float(result!.consolidatedWeather[0].maxTemp), humidity: Float(result!.consolidatedWeather[0].humidity), windSpeed: Float(result!.consolidatedWeather[0].windSpeed), windDirection: Float(result!.consolidatedWeather[0].windDirection), latitude: Double(components[0])!, longitude: Double(components[1])!))
                
            }
            else{
                let url = URL(string: "https://www.metaweather.com/api/location/"+cities[n]+"/")
                var result: MetaWeatherResponse?
                let group = DispatchGroup()
                group.enter()
                URLSession.shared.dataTask(with: url!, completionHandler: { data, response, error in
                    do {
                        result = try JSONDecoder().decode(MetaWeatherResponse.self, from: data!)
                        group.leave()
                    }
                    catch{
                        print("Error")
                    }
                }).resume()
                group.wait()
                
                let str = result!.lattLong
                let components = str.components(separatedBy: ",")
                
                self.records.append(WeatherRecord(cityName: result!.title, weatherIcon: "", weatherState: result!.consolidatedWeather[0].weatherStateName, temperature: Float(result!.consolidatedWeather[0].maxTemp), humidity: Float(result!.consolidatedWeather[0].humidity), windSpeed: Float(result!.consolidatedWeather[0].windSpeed), windDirection: Float(result!.consolidatedWeather[0].windDirection), latitude: Double(components[0])!, longitude: Double(components[1])!))
            }

        }
        
    }
    
    
    
    struct WeatherRecord:Identifiable {
        var id: UUID = UUID()
        var cityName: String
        var weatherState: String = "Heavy Rain"
        var temperature: Float = Float.random(in: -10.0 ... 30.0)
        var humidity:Float = Float.random(in: 0...100)
        var windSpeed:Float = Float.random(in: 0...20)
        var windDirection: Float = Float.random(in: 0..<360)
        let weatherIcon: String
        var latitude: Double = Double.random(in: 0..<360)
        var longitude: Double = Double.random(in: 0..<360)
        
        @State var region: MKCoordinateRegion
        struct Place: Identifiable {
            let id = UUID()
            let coordinate: CLLocationCoordinate2D
        }
        @State var places: [Place]
        
    
        init(cityName:String, weatherIcon: String, weatherState: String, temperature: Float, humidity: Float,
             windSpeed: Float, windDirection:Float, latitude: Double, longitude: Double){
            self.cityName = cityName
            self.weatherIcon = iconMap[weatherState] ?? defaultIcon
            self.weatherState = weatherState
            self.temperature = temperature
            self.humidity = humidity
            self.windSpeed = windSpeed
            self.windDirection = windDirection
            self.latitude = latitude
            self.longitude = longitude
            
            let myRegion = MKCoordinateRegion(
                center: CLLocationCoordinate2D(
                    latitude: CLLocationDegrees(self.latitude),
                    longitude: CLLocationDegrees(self.longitude)
                ),
                span: MKCoordinateSpan(
                    latitudeDelta: 1.0,
                    longitudeDelta: 1.0
                )
            )
            _region = State(initialValue: myRegion)
            
            let myPlaces = [
                Place(coordinate: .init(latitude: latitude, longitude: longitude)),
            ]
            _places = State(initialValue: myPlaces)
            
        }
        
    }
    
    //metoda do odświeżania tamperatury
    mutating func refresh(record: WeatherRecord, i:Int){
        records[i].temperature = Float.random(in: -10.0 ... 30.0)
        print("Refrashing record: \(record)")
    }

    //metoda służąca do cyklicznego zmieniania wyświetlanych parametrów po kliknięciu
    mutating func refreshIndex(index: Int)->Int{
        if index>=3{
            return 0
        }else{
            return index+1
        }
    }
}
