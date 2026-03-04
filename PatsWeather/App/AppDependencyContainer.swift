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
    
    
    private lazy var searchViewModel: SearchViewModel = SearchViewModel(
        geocodingService: makeGeocodingService(),
        lastKnownStateStore: makeLastKnownAppStateStore()
    )
    
    private lazy var weatherViewModel: WeatherViewModel = WeatherViewModel(
        weatherService: makeWeatherService(),
        iconLoader: makeIconLoader(),
        lastKnownStateStore: makeLastKnownAppStateStore(),
        locationService: makeLocationService()
    )
    
    func makeLastKnownAppStateStore() -> LastKnownAppStateStoring {
        return lastKnownAppStateStore
    }
    
    func makeLaunchStateRestorer() -> AppLaunchStateRestoring {
        launchStateRestorer
    }
    
    func makeIconLoader() -> WeatherIconLoading {
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
    
    func makeSearchViewModel() -> SearchViewModel {
        return searchViewModel
    }
    
    func makeSearchViewController() -> SearchViewController {
        let viewModel = makeSearchViewModel()
        let weatherViewModel = makeWeatherViewModel()
        return SearchViewController(searchViewModel:  viewModel, weatherViewModel: weatherViewModel)
    }
    
    func makeWeatherViewModel() ->WeatherViewModel {
        return weatherViewModel
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
        return AppConfiguration.openWeatherApiKey
    }
}
