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
    private let fetcher = MetaWeatherFetcher()
    
    struct WeatherRecord:Identifiable {
        var id: UUID = UUID()
        var cityName: String
        var weatherState: String = "Heavy Rain"
        var temperature: Float = Float.random(in: -10.0 ... 30.0)
        var humidity: Float = Float.random(in: 0...100)
        var windSpeed:Float = Float.random(in: 0...20)
        var windDirection: Float = Float.random(in: 0..<360)
        let weatherIcon: String
        var latitude: Double = Double.random(in: 0..<360)
        var longitude: Double = Double.random(in: 0..<360)
        var sunset: String = ""
        var sunrise: String = ""
        var air_pressure: Double = Double.random(in: 0..<2000)
        var visibility: Float = Float.random(in: 0...100)
        var weather_state_name: String = ""
        
        init(response: MetaWeatherResponse){
            cityName = response.title
            weatherState = response.consolidatedWeather[0].weatherStateName
            weatherIcon = iconMap[weatherState] ?? defaultIcon
            latitude = Double(Float(response.lattLong.components(separatedBy: ",")[0].trimmingCharacters(in: .whitespaces))!)
            longitude = Double(Float(response.lattLong.components(separatedBy: ",")[1].trimmingCharacters(in: .whitespaces))!)
            temperature = Float(response.consolidatedWeather[0].theTemp)
            humidity = Float(response.consolidatedWeather[0].humidity)
            windSpeed = Float(response.consolidatedWeather[0].windSpeed)
            windDirection = Float(response.consolidatedWeather[0].windDirection)
            sunset = response.sunSet
            sunrise = response.sunRise
            air_pressure = response.consolidatedWeather[0].airPressure
            visibility = Float(response.consolidatedWeather[0].visibility)
            weather_state_name =  response.consolidatedWeather[0].weatherStateName

        }
        
        
    }
    
    
    //metoda do odświeżania tamperatury
    mutating func refresh(record: WeatherRecord){
        let idx = records.firstIndex(where: {$0.id == record.id} )

        records[idx!].temperature = Float.random(in: -10.0 ... 30.0)
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
