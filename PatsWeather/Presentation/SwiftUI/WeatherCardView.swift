//
//  W.swift
//  PatsWeather
//
//  Created by Patrick Moscova on 3/2/26.
//

import SwiftUI

struct WeatherCardView : View {
    let weatherViewModel: WeatherViewModel
    
    var body: some View {
        
    }
    
    @ViewBuilder
    private func header(report: WeatherReport) -> some View {
        HStack(alignment: .center, spacing: 12) {
            if let image = weatherViewModel.iconImage {
                Image(uiImage: image)
                    .resizable()
                    .frame(width: 48, height: 48)
                    .accessibilityIdentifier(K.Accessibility.Weather.iconImage)
            }else{
                switch weatherViewModel.iconStatus {
                    case .loading(let code):
                        ProgressView()
                            .accessibilityIdentifier(K.Accessibility.WeatherCard.loadingStatusLabel)
                    default:
                        EmptyView()
                }
            }
        }
        
        VStack(alignment: .leading, spacing: 4){
            switch weatherViewModel.weatherStatus {
                case .success(let report, let locationName):
                    Text(locationName)
                        .font(.headline)
                        .accessibilityIdentifier(K.Accessibility.Weather.locationLabel)
                    Text(report.current.condition.description ?? "")
                default:
                    EmptyView()
            }
        }
        
        //Spacer
        Spacer()
        Text("\(Int(report.current.temperature))°")
            .font(.largeTitle)
            .accessibilityIdentifier(K.Accessibility.Weather.temperatureLabel)
    }
    
    @ViewBuilder
    private func details(report: WeatherReport) -> some View{
        VStack(alignment: .leading, spacing: 6){
            Text("Feels like \(Int(report.current.feelsLike ?? 0.0))")
                .accessibilityIdentifier(K.Accessibility.Weather.feelsLikeLabel)
            Text("Humidity \(report.current.humidity ?? 0)%")
        }
        .font(.footnote)
    }
    
}
