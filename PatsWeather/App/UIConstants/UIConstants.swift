//
//  UIConstants.swift
//  PatsWeather
//
//  Created by Patrick Moscova on 3/2/26.
//


import Foundation

struct K {
    
    struct Accessibility {
        
        struct Search {
            static let titleLabel = "SEARCH_title_label"
            static let cityTextField = "SEARCH_city_textfield"
            static let searchButton = "SEARCH_search_button"
            static let useLocationButton = "SEARCH_use_location_button"
            static let errorLabel = "SEARCH_error_label"
            static let weatherContainer = "SEARCH_weather_container"
            
        }
        
        struct Weather {
            static let locationLabel = "WEATHER_location_label"
            static let temperatureLabel = "WEATHER_temperature_label"
            static let conditionLabel = "WEATHER_condition_label"
            static let highLowLabel = "WEATHER_high_low_label"
            static let windLabel = "WEATHER_wind_label"
            static let humidityLabel = "WEATHER_humidity_label"
            static let iconImage = "WEATHER_icon_image"
            static let feelsLikeLabel = "WEATHER_feels_like_label"
        }
        
        struct WeatherCard {
            static let errorLabel = "WEATHER_CARD_error_text"
            static let idleStatusLabel =  "WEATHER_CARD_idle_text"
            static let loadingStatusLabel = "WEATHER_CARD_loading_text"
        }
    }
    
    struct LabelText {
        
        struct Search {
            static let title = "Search"
            static let cityPlaceholder = "Enter a US city"
            static let searchButtonTitle = "Search Weather"
            static let useLocationButtonTitle = "Use My Location"
            static let emptyState = "Search for a city to see the weather."
        }
        
        struct Weather {
            static let title = "Weather"
            static let windPrefix = "Wind"
            static let humidityPrefix = "Humidity"
            static let feelsLikePrefix = "Feels like"
            static let errorLabel = "Error"
            static let idleStatusLabel =  "Search for a city, or use your location."
            static let loadingStatusLabel = "Loading weather..."
        }
        
        struct Errors {
            static let genericTitle = "Something went wrong"
            static let genericMessage = "Please try again."
            static let invalidCityMessage = "Please enter a valid US city."
            static let locationDeniedMessage = "Location access is off. You can enable it in Settings."
        }
        
        
    }
}
