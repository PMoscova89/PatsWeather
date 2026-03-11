//
//  WeatherDisplay.swift
//  PatsWeather
//
//  Created by Patrick Moscova on 3/2/26.
//

import UIKit
import SwiftUI

final class WeatherViewController: UIViewController {
    private let viewModel: WeatherViewModel
    override func viewDidLoad() {
        super.viewDidLoad()
        title = K.LabelText.Weather.title
        view.backgroundColor = .systemBackground
        
        let cardView = WeatherCardView(weatherViewModel: viewModel)
        let hostingController = UIHostingController(rootView: cardView)
        
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            hostingController.view.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 1)
        ])
        
        hostingController.didMove(toParent: self)
        
    }
    
    init(viewModel: WeatherViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
