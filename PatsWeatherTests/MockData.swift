import Foundation
@testable import PatsWeather

struct MockData {
    static let sampleWeatherJSON = """
    {
      "current": {
        "temperature": 20.5,
        "feelsLike": 19.0,
        "humidity": 54,
        "windSpeed": 3.5,
        "condition": {
          "description": "clear sky",
          "icon": "01d"
        }
      }
    }
    """
    
    static let decodedWeatherReport: WeatherReport = WeatherReport(
        timezone: "UTC",
        current: WeatherReport.CurrentWeather(
            timestamp: Date(timeIntervalSince1970: 0),
            sunrise: nil,
            sunset: nil,
            temperature: 20.5,
            feelsLike: 19.0,
            humidity: 54,
            windSpeed: 3.5,
            condition: WeatherCondition(
                id: nil,
                main: nil,
                description: "clear sky",
                icon: "01d"
            )
        ),
        hourly: [],
        daily: [],
        alerts: []
    )
    
}
