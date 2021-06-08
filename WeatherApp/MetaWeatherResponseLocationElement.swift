//
//  MetaWeatherResponseLocation.swift
//  WeatherApp
//
//  Created by Karolina Matuszczyk on 31/05/2021.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let metaWeatherResponseLocation = try? newJSONDecoder().decode(MetaWeatherResponseLocation.self, from: jsonData)
import Foundation

// MARK: - MetaWeatherResponseLocationElement
struct MetaWeatherResponseLocationElement: Decodable {
    let distance: Int
    let title: String?
    let locationType: LocationType?
    let woeid: Int
    let lattLong: String?

    enum CodingKeys: String, CodingKey {
        case distance
        case title
        case locationType
        case woeid
        case lattLong
    }
    enum LocationType: String, Codable {
        case city = "City"
    }
}

//typealias MetaWeatherResponseLocation = [MetaWeatherResponseLocationElement]

