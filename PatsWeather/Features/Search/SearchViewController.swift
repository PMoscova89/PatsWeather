//
//  Search.swift
//  PatsWeather
//
//  Created by Patrick Moscova on 3/2/26.
//

import UIKit

final class SearchViewController: UIViewController {
    var onShowWeather: (() -> Void)?
    
    private lazy var showWeatherButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Go To Weather", for: .normal)
        button.addTarget(self, action: #selector(didTapShowWeather), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search"
        view.backgroundColor = .systemBackground
        view.addSubview(showWeatherButton)
        showWeatherButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            showWeatherButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            showWeatherButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    
    @objc private func didTapShowWeather(){
        onShowWeather?()
    }
}
