//
//  Search.swift
//  PatsWeather
//
//  Created by Patrick Moscova on 3/2/26.
//

import UIKit

final class SearchViewController: UIViewController {
    private let viewModel: SearchViewModel
    var onShowWeather: (() -> Void)?
    
    private lazy var showWeatherButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Go To Weather", for: .normal)
        button.addTarget(self, action: #selector(didTapShowWeather), for: .touchUpInside)
        return button
    }()
    
    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
