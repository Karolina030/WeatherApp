//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by Karolina Matuszczyk on 04/05/2021.
//

import Foundation

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
    
    init(cities: Array<String>){
        records = Array<WeatherRecord>()
        for city in cities{
            records.append(WeatherRecord(cityName: city, weatherIcon: ""))
        }
    }
    
    struct WeatherRecord:Identifiable {
        var id: UUID = UUID()
        var cityName: String
        var weatherState: String = "Light Cloud"
        var temperature: Float = Float.random(in: -10.0 ... 30.0)
        var humidity:Float = Float.random(in: 0...100)
        var windSpeed:Float = Float.random(in: 0...20)
        var windDirection: Float = Float.random(in: 0..<360)
        let weatherIcon: String
    
        init(cityName:String, weatherIcon: String){
            self.cityName = cityName
            self.weatherIcon = iconMap[weatherState] ?? defaultIcon
        }
        
    }
    
    mutating func refresh(record: WeatherRecord, i:Int){
        records[i].temperature = Float.random(in: -10.0 ... 30.0)
        print("Refrashing record: \(record)")
    }

//    mutating func refreshIndex(index: Int)->Int{
//        if index>=3{
//            return 0
//        }else{
//            return index+1
//        }
//    }
}
