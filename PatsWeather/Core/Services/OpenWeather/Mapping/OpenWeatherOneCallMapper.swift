//
//  OpenWeatherOneCallMapper.swift
//  PatsWeather
//
//  Created by Patrick Moscova on 3/3/26.
//

import Foundation

protocol OpenWeatherOneCallMapping{
    func mapToWeatherReport(_ dto: OpenWeatherOneCallDTO) -> WeatherReport?
    func mapToWeatherReport(_ dto: OpenWeatherCurrentWeatherDTO) -> WeatherReport?
}

struct OpenWeatherOneCallMapper: OpenWeatherOneCallMapping {


    func mapToWeatherReport(_ dto: OpenWeatherOneCallDTO) -> WeatherReport? {
        guard let timezone = dto.timezone else {
            return nil
        }
        
        let current = mapCurrent(dto.current)
        let hourly = mapHourly(dto.hourly)
        let daily = mapDaily(dto.daily)
        let alerts = mapAlerts(dto.alerts)
        
        return WeatherReport(
            timezone: timezone,
            current: current,
            hourly: hourly,
            daily: daily,
            alerts: alerts
        )
    }
    
    private func mapCurrent(_ current: OpenWeatherOneCallDTO.CurrentDTO?) -> WeatherReport.CurrentWeather {
        let condition = mapCondition(current?.weather)
        
        return WeatherReport.CurrentWeather(
            timestamp: date(fromUnix: current?.dt),
            sunrise: optionalDate(fromUnix: current?.sunrise),
            sunset: optionalDate(fromUnix: current?.sunset),
            temperature: current?.temp ?? 0.0,
            feelsLike: current?.feelsLike,
            humidity: current?.humidity,
            windSpeed: current?.windSpeed,
            condition: condition
        )
    }
    
    private func mapHourly(_ hourly: [OpenWeatherOneCallDTO.HourlyDTO]?) -> [WeatherReport.HourlyForecast] {
        guard let hourly = hourly, !hourly.isEmpty else {
            return []
        }
        
        return hourly.map { item in
            WeatherReport.HourlyForecast(
                timestamp: date(fromUnix: item.dt),
                temperature: item.temp,
                precipitationChance: item.pop,
                condition: mapCondition(item.weather)
            )
        }
    }
    
    private func mapDaily(_ daily: [OpenWeatherOneCallDTO.DailyDTO]?) -> [WeatherReport.DailyForecast] {
        guard let daily = daily, !daily.isEmpty else {
            return []
        }
        
        return daily.map { item in
            WeatherReport.DailyForecast(
                timestamp: date(fromUnix: item.dt),
                sunrise: optionalDate(fromUnix: item.sunrise),
                sunset: optionalDate(fromUnix: item.sunset),
                minTemp: item.temp?.min,
                maxTemp: item.temp?.max,
                condition: mapCondition(item.weather),
                summary: item.summary
            )
        }
    }
    
    private func mapAlerts(_ alerts: [OpenWeatherOneCallDTO.AlertDTO]?) -> [WeatherReport.WeatherAlert] {
        guard let alerts = alerts, !alerts.isEmpty else {
            return []
        }
        
        return alerts.map { item in
            WeatherReport.WeatherAlert(
                senderName: item.senderName,
                event: item.event,
                start: optionalDate(fromUnix: item.start),
                end: optionalDate(fromUnix: item.end),
                description: item.description,
                tags: item.tags ?? []
            )
        }
    }
    
    private func mapCondition(_ weather: [OpenWeatherOneCallDTO.WeatherDTO]?) -> WeatherCondition {
        // weather is an array and it might be missing or empty.
        // We safely take the first item if it exists.
        let first = weather?.first
        
        return WeatherCondition(
            id: first?.id,
            main: first?.main,
            description: first?.description,
            icon: first?.icon
        )
    }
    
    private func date(fromUnix unix: Int?) -> Date {
        // If dt is missing, we return epoch, because domain requires a Date.
        // You can choose a different default later.
        let seconds = TimeInterval(unix ?? 0)
        return Date(timeIntervalSince1970: seconds)
    }
    
    private func optionalDate(fromUnix unix: Int?) -> Date? {
        guard let unix = unix else { return nil }
        return Date(timeIntervalSince1970: TimeInterval(unix))
    }
}

extension OpenWeatherOneCallMapper {
    
    func mapToWeatherReport(_ dto: OpenWeatherCurrentWeatherDTO) -> WeatherReport? {
        let timezoneName = dto.name ?? "Unknown"
        
        let condition = WeatherCondition(
            id: dto.weather?.first?.id,
            main: dto.weather?.first?.main,
            description: dto.weather?.first?.description,
            icon: dto.weather?.first?.icon
        )
        
        let current = WeatherReport.CurrentWeather(
            timestamp: date(fromUnix: dto.dt),
            sunrise: optionalDate(fromUnix: dto.sys?.sunrise),
            sunset: optionalDate(fromUnix: dto.sys?.sunset),
            temperature: dto.main?.temp ?? 0.0,
            feelsLike: dto.main?.feelsLike,
            humidity: dto.main?.humidity,
            windSpeed: dto.wind?.speed,
            condition: condition
        )
        
        return WeatherReport(
            timezone: timezoneName,
            current: current,
            hourly: [],
            daily: [],
            alerts: []
        )
    }
}
