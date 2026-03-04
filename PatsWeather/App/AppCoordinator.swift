//
//  AppCoordinator.swift
//  PatsWeather
//
//  Created by Patrick Moscova on 3/2/26.
//

import UIKit

final class AppCoordinator: Coordinator {
    private let window: UIWindow
    private let navigationController: UINavigationController
    private let dependencies: AppDependencyContainer
    
    init(window: UIWindow, dependencies: AppDependencyContainer){
        self.window = window
        self.dependencies = dependencies
        self.navigationController = UINavigationController()
    }
    
    func start(){
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        showSearch()
        
    }
    
    private func showSearch(){
        let vc = dependencies.makeSearchViewController()

        navigationController.setViewControllers([vc], animated: true)
    }
    
    private func showWeather() {
        let vc = dependencies.makeWeatherViewController()
        navigationController.pushViewController(vc, animated: true)
    }
}
