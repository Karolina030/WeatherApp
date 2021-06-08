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
        let url = URL(string: "https://www.metaweather.com/api/location/44418/")!
        return URLSession.shared.dataTaskPublisher(for: url)
            .map{$0.data}
            .decode(type: MetaWeatherResponse.self, decoder: JSONDecoder())
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
        
    }
    
    
}
