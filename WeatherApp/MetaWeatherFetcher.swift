//
//  MetaWeatherFetcher.swift
//  WeatherApp
//
//  Created by Karolina Matuszczyk on 18/05/2021.
//

import Foundation
import Combine

class MetaWeatherFetcher{
    
    // funkcja generująca Publisher
    func forecast(forId woeId: String) ->
        AnyPublisher<MetaWeatherResponse, Error>{
        let url = URL(string: "https://www.metaweather.com/api/location/"+woeId+"/")!
        return URLSession.shared.dataTaskPublisher(for: url)
            .map{$0.data}
            .receive(on: RunLoop.main)
            .decode(type: MetaWeatherResponse.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
        
    }
    
    func checkCity(forId lat: String, forId lon: String) ->
        AnyPublisher<Array<MetaWeatherResponseLocationElement>, Error>{
        let url = URL(string: "https://www.metaweather.com/api/location/search/?lattlong="+lat+","+lon)!
        return URLSession.shared.dataTaskPublisher(for: url)
            .map{$0.data}
            .receive(on: RunLoop.main)
            .decode(type: Array<MetaWeatherResponseLocationElement>.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
        
    }
    
}
