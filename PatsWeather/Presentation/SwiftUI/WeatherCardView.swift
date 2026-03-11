//
//  W.swift
//  PatsWeather
//
//  Created by Patrick Moscova on 3/2/26.
//

import SwiftUI

private struct WeatherCardContainer<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .padding(16)
            .frame(minWidth: 0, maxWidth: 520, alignment: .leading)
            .frame(maxWidth: .infinity, alignment: .center)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.4), Color.indigo.opacity(0.6)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 16))
            )
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: Color.black.opacity(0.25), radius: 12, x: 0, y: 4)
    }
}

private struct MetricChip: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .foregroundColor(.white.opacity(0.8))
                .font(.footnote)
            Text(title)
                .foregroundColor(.white.opacity(0.8))
                .font(.footnote)
            Text(value)
                .foregroundColor(.white)
                .font(.footnote)
                .bold()
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
        .background(Color.white.opacity(0.15))
        .clipShape(Capsule())
    }
}

private func symbol(for iconCode: String) -> String {
    switch iconCode {
    case "01d": return "sun.max.fill"
    case "01n": return "moon.fill"
    case "02d": return "cloud.sun.fill"
    case "02n": return "cloud.moon.fill"
    case "03d", "03n": return "cloud.fill"
    case "04d", "04n": return "smoke.fill"
    case "09d", "09n": return "cloud.drizzle.fill"
    case "10d": return "cloud.sun.rain.fill"
    case "10n": return "cloud.moon.rain.fill"
    case "11d", "11n": return "cloud.bolt.fill"
    case "13d", "13n": return "snowflake"
    case "50d", "50n": return "cloud.fog.fill"
    default: return "questionmark"
    }
}

private struct WeatherCardContent: View {
    let report: WeatherReport
    let locationName: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            VStack(alignment: .leading, spacing: 6) {
                Text(locationName)
                    .font(.title2)
                    .bold()
                    .foregroundColor(.white)
                    .accessibilityIdentifier(K.Accessibility.Weather.locationLabel)
                    .layoutPriority(1)
                    .lineLimit(2)
                    .minimumScaleFactor(0.7)
                    .truncationMode(.tail)
                Text(report.current.condition.description ?? "")
                    .foregroundColor(.white.opacity(0.8))
                    .font(.subheadline)
            }
            
            HStack(alignment: .bottom, spacing: 12) {
                if let iconCode = report.current.condition.icon {
                    Image(systemName: symbol(for: iconCode))
                        .font(.system(size: 56))
                        .foregroundColor(.white)
                        .accessibilityIdentifier(K.Accessibility.Weather.iconImage)
                }
                Text("\(Int(report.current.temperature))°")
                    .font(.system(size: 70, weight: .bold))
                    .foregroundColor(.white)
                    .accessibilityIdentifier(K.Accessibility.Weather.temperatureLabel)
            }
            .frame(minHeight: 70)
            
            HStack(spacing: 14) {
                MetricChip(
                    icon: "thermometer",
                    title: "Feels like",
                    value: "\(Int(report.current.feelsLike ?? 0))°"
                )
                MetricChip(
                    icon: "drop.fill",
                    title: "Humidity",
                    value: "\(report.current.humidity ?? 0)%"
                )
                MetricChip(
                    icon: "wind",
                    title: "Wind",
                    value: "\(Int(report.current.windSpeed ?? 0)) km/h"
                )
            }
        }
    }
}

struct WeatherCardView : View {
    let weatherViewModel: WeatherViewModel
    
    var body: some View {
        VStack {
            WeatherCardContainer {
                switch weatherViewModel.weatherStatus {
                case .idle:
                    Text(K.LabelText.Weather.idleStatusLabel)
                        .accessibilityIdentifier(K.Accessibility.WeatherCard.idleStatusLabel)
                case .loading:
                    HStack(spacing: 8) {
                        ProgressView()
                        Text(K.LabelText.Weather.loadingStatusLabel)
                            .accessibilityLabel(K.Accessibility.WeatherCard.loadingStatusLabel)
                    }
                    .accessibilityIdentifier(K.Accessibility.WeatherCard.loadingStatusLabel)
                case .failed(let message):
                    Text(message)
                        .foregroundStyle(.red)
                        .accessibilityIdentifier(K.Accessibility.WeatherCard.errorLabel)
                case .success(let report, let locationName):
                    WeatherCardContent(report: report, locationName: locationName)
                }
            }
            .padding(.horizontal)
            .padding(.top, 60)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .accessibilityIdentifier(K.Accessibility.WeatherCard.container)
    }
}
