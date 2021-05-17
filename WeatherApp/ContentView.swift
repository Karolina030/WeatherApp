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
                    
                }
            }.padding()
            //padding w celu uzyskania marginesów
        }
    }
}

struct WeatherRecordView: View{
    var record: WeatherModel.WeatherRecord
    var viewModel = WeatherViewModel()
    var iter: Int
    @State var index = 0
    //stałe
    let rectangleRadius = 25.0
    let scale = 1
    let cellHeight = 60.0
    let textWidth = 160.0
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: CGFloat(rectangleRadius))
                .stroke()
            HStack{
                GeometryReader{geometry in
                    Text(record.weatherIcon)
                        .font(.system(size:CGFloat(scale)*geometry.size.width))
                }
                Spacer() // uzyskanie wyrównania do lewej
                //wyrównanie tekstu do lewej
                VStack(alignment: .leading){
                    Text(record.cityName)
                        .onTapGesture {
                            index = viewModel.refreshIndex(index:index)
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
                }.frame(width: CGFloat(textWidth))
                Spacer() // uzyskanie wyrównania do prawej
                Text("🔄")
                    .font(.largeTitle).onTapGesture {
                        viewModel.refresh(record:record, i:iter)
                    }
            }.frame(height: CGFloat(cellHeight)).padding(.trailing, 15).padding(.leading, 15)
            //ustalenie wysokości komórek oraz marginesów
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: WeatherViewModel())
    }
}
