//
//  ContentView.swift
//  WeatherApp
//
//  Created by Karolina Matuszczyk on 04/05/2021.
//

import SwiftUI
import MapKit
//import CLLocationCoordinate2D

struct ContentView: View {
    
    @StateObject var viewModel = WeatherViewModel()
        
    var body: some View {
        NavigationView{
            ZStack{

                    VStack(alignment: .leading){

                        List(viewModel.records) { record in
                            NavigationLink(destination: WeatherDetail(viewModel: viewModel, record:record)) {
                                WeatherRecordView(record: record, viewModel: viewModel)
                            }
                        }
                        

                    }
                    //padding w celu uzyskania marginesów
         //       }

            }.navigationTitle("Weather")
        }
        
    }
}

struct WeatherRecordView: View{
    
    var record: WeatherModel.WeatherRecord
    var viewModel = WeatherViewModel()
    @State var index = 0
    //stałe
    let rectangleRadius = 25.0
    let scale = 1
    let cellHeight = 60.0
    let textWidth = 130.0
    @State private var showingSheet = false


    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: 50.0,
            longitude: 20.0
        ),
        span: MKCoordinateSpan(
            latitudeDelta: 1.0,
            longitudeDelta: 1.0
        )
    )

    struct Place: Identifiable {
        let id = UUID()
        let coordinate: CLLocationCoordinate2D
    }

    @State private var places: [Place] = [
        Place(coordinate: .init(latitude: 50.0, longitude: 20.0)),
    ]

    var body: some View {
    
        return ZStack{

            HStack{
                GeometryReader{geometry in
                    Text(record.weatherIcon)
                        .font(.system(size: CGFloat(scale)*geometry.size.width))
                }
                Spacer() // uzyskanie wyrównania do lewej
                //wyrównanie tekstu do lewej
                VStack(alignment: .leading){
                    Text(record.cityName)
                        .onTapGesture {
                            index = viewModel.refreshIndex(index:index)
                        }.font(/*@START_MENU_TOKEN@*/.footnote/*@END_MENU_TOKEN@*/)
                    
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
                Text("🔄")
                    .font(.system(size: 25.0)).onTapGesture {
                        viewModel.refresh(record:record)
                    }
                Text("🗺")
                    .font(.system(size: 25.0)).onTapGesture {
                        showingSheet = true
                    }.sheet(isPresented: $showingSheet, content: {
                        VStack{
                            Map(coordinateRegion: $region, annotationItems: places) { place in
                            MapPin(coordinate: place.coordinate)
                        }.padding(.top)
                        }

                }).onAppear{
                    region = MKCoordinateRegion(
                        center: CLLocationCoordinate2D(
                            latitude: CLLocationDegrees(record.latitude),
                            longitude: CLLocationDegrees(record.longitude)
                        ),
                        span: MKCoordinateSpan(
                            latitudeDelta: 1.0,
                            longitudeDelta: 1.0
                        )
                    )
                
                    places = [
                        Place(coordinate: .init(latitude: record.latitude, longitude: record.longitude)),
                    ]
                }

            }
            //ustalenie wysokości komórek oraz marginesów
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: WeatherViewModel())
    }
}
