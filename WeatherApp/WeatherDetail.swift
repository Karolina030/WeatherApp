//
//  WeatherDetail.swift
//  WeatherApp
//
//  Created by Karolina Matuszczyk on 08/06/2021.
//

import SwiftUI

struct WeatherDetail: View {
    @StateObject var viewModel = WeatherViewModel()

    var record: WeatherModel.WeatherRecord
    
    
    var body: some View {
        

        ZStack{
            LinearGradient(gradient: Gradient(colors: [.white, .blue]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
            VStack{
                Text(" \(record.cityName)").font(.largeTitle)
                Text(" \(record.weather_state_name)").font(.headline)
                Text(" \(record.temperature, specifier: "%.1f")°C").font(.title)

                Spacer()
                HStack{
                    VStack{
                        Text("Sunrise")
                        Text("🌅").font(.largeTitle)
                        Text("\(formatStringDate(date: record.sunrise))")
                        
                    }.padding()
                    VStack{
                        Text("Sunset")
                        Text("🌇").font(.largeTitle)
                        Text("\(formatStringDate(date: record.sunset))")
                        
                    }.padding()

                }

                Spacer()
                Text("Visibility: \(record.visibility, specifier: "%.0f")%")
                Text("Air Pressure: \(record.air_pressure, specifier: "%.0f")hPa")
                Spacer()

            }
        }

        
    }
    
    
    func formatStringDate(date: String) -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            let newDate = dateFormatter.date(from: date)
            dateFormatter.setLocalizedDateFormatFromTemplate("HH:mm:ss")
            return dateFormatter.string(from: newDate!)
    }
}


