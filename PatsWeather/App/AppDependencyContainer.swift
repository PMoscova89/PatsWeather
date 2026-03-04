//
//  AppDepencyContainer.swift
//  PatsWeather
//
//  Created by Patrick Moscova on 3/2/26.
//
import UIKit
import CoreLocation

final class AppDependencyContainer {
    
    private lazy var urlBuilder: URLBuilding = URLBuilder()
    private lazy var requestBuilder: RequestBuilding = RequestBuilder(urlBuilder: urlBuilder)
    private lazy var responseValidator: ResponseValidating = ResponseValidator()
    
    private lazy var memoryCache: ImageCaching = InMemoryImageCache()
    private lazy var diskCache: ImageCaching = DiskImageCache()
    
    private lazy var iconURLBuilder: WeatherIconURLBuilding =  WeatherIconURLBuilder()
    
    private lazy var iconLoader: WeatherIconLoading =
    WeatherIconLoader(urlBuilder: iconURLBuilder,
                      httpClient: httpClient,
                      memoryCache: memoryCache,
                      diskCache: diskCache
    )
    
    private lazy var httpClient: HTTPClient = DefaultHTTPClient(
        session: URLSession.shared,
        validator: responseValidator
    )
    
    private lazy var openWeatherConfig: OpenWeatherConfig = OpenWeatherConfig(
        apiKey: provideOpenWeatherAPIKey(),
        units: .metric,
        languageCode: "en"
    )
    
    private lazy var locationService: LocationServiceType = CLLocationManagerLocationService(manager: CLLocationManager())
    
    private lazy var openWeatherEndpointFactory: OpenWeatherEndpointBuilding = OpenWeatherEndpointFactory(
        config: openWeatherConfig
    )
    
    private lazy var geocodingService: GeocodingServiceType = OpenWeatherGeocodingService(
        endpointFactory: openWeatherEndpointFactory,
        requestBuilder: requestBuilder,
        httpClient: httpClient
    )
    
    private lazy var weatherService: WeatherServiceType = OpenWeatherWeatherService(
        endpointFactory: openWeatherEndpointFactory, requestBuilder: requestBuilder, httpClient: httpClient
    )
    
    private lazy var lastKnownAppStateStore: LastKnownAppStateStoring = UserDefaultsLastKnownAppStateStore()
    private lazy var launchStateRestorer: AppLaunchStateRestoring = StartupStateController(store: lastKnownAppStateStore)
    
    func makeLastKnownAppStateStore() -> LastKnownAppStateStoring {
        return lastKnownAppStateStore
    }
    
    func makeLaunchStateRestorer() -> AppLaunchStateRestoring {
        launchStateRestorer
    }
    
    func makeIconLodaer() -> WeatherIconLoading {
        iconLoader
    }
    
    func makeGeocodingService() -> GeocodingServiceType{
        geocodingService
    }
    
    func makeWeatherService() -> WeatherServiceType{
        return weatherService
    }
    
        
    
    
    func makeAppCoordinator(window: UIWindow) -> AppCoordinator {
        AppCoordinator(window: window, dependencies: self )
    }
    
    func makeSearchViewMocel() -> SearchViewModel {
        SearchViewModel()
    }
    
    func makeSearchViewController() -> SearchViewController {
        let viewModel = makeSearchViewMocel()
        return SearchViewController(viewModel:  viewModel)
    }
    
    func makeWeatherViewModel() ->WeatherViewModel {
        WeatherViewModel()
    }
    
    func makeWeatherViewController() -> WeatherViewController {
        let viewModel = makeWeatherViewModel()
        return WeatherViewController(viewModel: viewModel)
    }
    
    func makeRequestBuilder() -> RequestBuilding {
        requestBuilder
    }
    
    func makeHTTPClient() -> HTTPClient {
        httpClient
    }
    
    func makeLocationService() -> LocationServiceType {
        return locationService
    }
    
    private func provideOpenWeatherAPIKey() -> String{
        return "REPLACE_ME"
    }
}
