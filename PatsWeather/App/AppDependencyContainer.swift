//
//  AppDepencyContainer.swift
//  PatsWeather
//
//  Created by Patrick Moscova on 3/2/26.
//
import UIKit
final class AppDependencyContainer {
    
    private lazy var urlBuilder: URLBuilding = URLBuilder()
    private lazy var requestBuilder: RequestBuilding = RequestBuilder(urlBuilder: urlBuilder)
    private lazy var responseValidator: ResponseValidating = ResponseValidator()
    private lazy var httpClient: HTTPClient = DefaultHTTPClient(
        session: URLSession.shared,
        validator: responseValidator
    )
    
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
}
