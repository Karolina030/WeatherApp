//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Karolina Matuszczyk on 04/05/2021.
//

import Foundation

class WeatherViewModel:ObservableObject {
    
    @Published private(set) var model:WeatherModel = WeatherModel(cities: ["Venice", "Paris", "Berlin", "Warsaw", "Barcelona", "London", "Prague", "Venice", "Paris", "Berlin", "Warsaw", "Barcelona", "London", "Prague"])
    
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
