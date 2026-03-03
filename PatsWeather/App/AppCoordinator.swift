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
    
    init(window: UIWindow){
        self.window = window
        self.navigationController = UINavigationController()
    }
    
    func start(){
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        showSearch()
        
    }
    
    private func showSearch(){
        let vc = SearchViewController()
        vc.onShowWeather = {[weak self] in
            self?.showWeather()
        }
        navigationController.setViewControllers([vc], animated: true)
    }
    
    private func showWeather() {
        let vc = WeatherViewController()
        navigationController.pushViewController(vc, animated: true)
    }
}
