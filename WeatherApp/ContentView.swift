//
//  ContentView.swift
//  WeatherApp
//
//  Created by Karolina Matuszczyk on 04/05/2021.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var viewModel = WeatherViewModel()
    var body: some View {
        ScrollView(.vertical){ // możliwość przewijanie listy miast
            VStack(alignment: .leading){

                ForEach(0..<viewModel.records.count){iter in
                    WeatherRecordView(record: viewModel.records[iter], viewModel: viewModel, iter:iter)
                    
                }.frame(height: 60) //ustalenie wysokości komórek

            }.padding()
        }
    }
}

struct WeatherRecordView: View{
    var record: WeatherModel.WeatherRecord
    var viewModel = WeatherViewModel()
    var iter: Int
    @State var index = 0
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 25.0)
                .stroke()
            HStack{
                GeometryReader{geometry in
                    Text(record.weatherIcon)
                        .padding(-2)
                        .font(.system(size:0.9*geometry.size.width))
                }
                Spacer() // uzyskanie wyrównania do lewej
                VStack(alignment: .leading){
                    Text(record.cityName)
                        .onTapGesture {
                            if index>=3{
                                index = 0
                            }else{
                                index = index+1
                            }
                        }
                    
                    switch index{
                    case 0:
                        Text("Temperature: \(record.temperature, specifier: "%.1f")°C")
                            .font(.caption)
                    case 1:
                        Text("Humidity: \(record.humidity, specifier: "%.0f")%")
                            .font(.caption)

                    case 2:
                        Text("Wind speed: \(record.windSpeed, specifier: "%.0f")km/h")
                            .font(.caption)

                    case 3:
                        Text("Wind direction: \(record.windDirection, specifier: "%.0f")°")
                            .font(.caption)

                    default:
                        Text("Temperature: \(record.temperature, specifier: "%.1f")°C")
                            .font(.caption)
                    }
                }.frame(width: 160, height: 60)

                Spacer() // uzyskanie wyrównania do prawej
                Text("🔄")
                    .font(.largeTitle).onTapGesture {
                        viewModel.refresh(record:record, i:iter)
                    }
            }.frame(width: 270, height: 60).offset(x: 0, y: 0)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: WeatherViewModel())
    }
}
