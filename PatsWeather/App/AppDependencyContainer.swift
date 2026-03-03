//
//  AppDepencyContainer.swift
//  PatsWeather
//
//  Created by Patrick Moscova on 3/2/26.
//
import UIKit
final class AppDependencyContainer {
    
    
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
}
