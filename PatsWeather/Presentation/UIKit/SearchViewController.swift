//
//  Search.swift
//  PatsWeather
//
//  Created by Patrick Moscova on 3/2/26.
//

import UIKit
import Observation
import SwiftUI

final class SearchViewController: UIViewController {
    private let searchViewModel: SearchViewModel
    private let weatherViewModel: WeatherViewModel
    
    private var weatherHostingController: UIHostingController<WeatherCardView>?
    
    private lazy var cityTextField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.borderStyle = .roundedRect
        field.autocapitalizationType = .words
        field.autocorrectionType = .no
        field.returnKeyType = .search
        field.placeholder = K.LabelText.Search.cityPlaceholder
        field.accessibilityIdentifier = K.Accessibility.Search.cityTextField
        field.addTarget(self, action: #selector(cityTextChanged), for: .editingChanged)
        return field
    }()
    
    private lazy var searchButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = K.LabelText.Search.searchButtonTitle
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.accessibilityIdentifier = K.Accessibility.Search.searchButton
        button.addTarget(self, action: #selector(didTapSearch), for: .touchUpInside)
        return button
    }()
    
    private lazy var locationButton : UIButton = {
        var config = UIButton.Configuration.tinted()
        config.title = K.LabelText.Search.useLocationButtonTitle
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.accessibilityIdentifier = K.Accessibility.Search.useLocationButton
        button.addTarget(self, action: #selector(didTapUseLocation), for: .touchUpInside)
        return button
    }()
    
    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = .preferredFont(forTextStyle: .footnote)
        label.textColor = .systemRed
        label.accessibilityIdentifier = K.Accessibility.Search.errorLabel
        label.isHidden = true
        return label
        
    }()
    
    private lazy var weatherContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.accessibilityIdentifier = K.Accessibility.Search.weatherContainer
        return view
    }()
    
    init(searchViewModel: SearchViewModel,
         weatherViewModel: WeatherViewModel
    ) {
        self.searchViewModel = searchViewModel
        self.weatherViewModel = weatherViewModel
        super.init(nibName: nil, bundle: nil)
        self.title = K.LabelText.Search.title
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        layoutUI()
        embedWeatherCard()
        bindSearchViewModel()
        bindWeatherViewModel()
    }
    
    
  
    
    
    
    
    private func layoutUI() {
        view.addSubview(cityTextField)
        view.addSubview(searchButton)
        view.addSubview(locationButton)
        view.addSubview(errorLabel)
        view.addSubview(weatherContainerView)
        
        NSLayoutConstraint.activate([
            cityTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            cityTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            cityTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            searchButton.topAnchor.constraint(equalTo: cityTextField.bottomAnchor, constant: 12),
            searchButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            locationButton.centerYAnchor.constraint(equalTo: searchButton.centerYAnchor),
            locationButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            errorLabel.topAnchor.constraint(equalTo: searchButton.bottomAnchor, constant: 12),
            errorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            errorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            weatherContainerView.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: 16),
            weatherContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            weatherContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            weatherContainerView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    private func embedWeatherCard(){
        let cardView = WeatherCardView(weatherViewModel: weatherViewModel)
        let hosting = UIHostingController(rootView: cardView)
        hosting.view.translatesAutoresizingMaskIntoConstraints = false
        hosting.view.backgroundColor = .clear
        
        addChild(hosting)
        weatherContainerView.addSubview(hosting.view)
        
        NSLayoutConstraint.activate([
            hosting.view.topAnchor.constraint(equalTo: weatherContainerView.topAnchor),
            hosting.view.leadingAnchor.constraint(equalTo: weatherContainerView.leadingAnchor),
            hosting.view.trailingAnchor.constraint(equalTo: weatherContainerView.trailingAnchor),
            hosting.view.bottomAnchor.constraint(equalTo: weatherContainerView.bottomAnchor)
        ])
        
        hosting.didMove(toParent: self)
        weatherHostingController = hosting
    }
    
    private func bindSearchViewModel(){
        withObservationTracking { [weak self] in
            guard let self else {return}
            _ = self.searchViewModel.cityInput
            _ = self.searchViewModel.status
            self.renderSearchState()
        } onChange: { [weak self] in
            guard let self else {return}
            DispatchQueue.main.async{
                self.bindSearchViewModel()
            }
        }
    }
    
    private func bindWeatherViewModel(){
        withObservationTracking { [weak self] in
            guard let self else { return}
            _ =  self.weatherViewModel.weatherStatus
            _ = self.weatherViewModel.iconStatus
            _ = self.weatherViewModel.iconImage
            self.renderUIKitState()
            
        } onChange: { [weak self] in
            guard let self else {return}
            DispatchQueue.main.async {
                self.bindWeatherViewModel()
            }
        }

    }
    
    
    private func renderSearchState() {
        switch searchViewModel.status {
            case .idle:
                setError(nil)
                setSearchingUI(isSearching: false)
            case .validating:
                setError(nil)
                setSearchingUI(isSearching: false)
            case .searching:
                setError(nil)
                setSearchingUI(isSearching: true)
            case .failed(let message):
                setError(message)
                setSearchingUI(isSearching: false)
            case .succeeded(let city, let coordinate):
                setError(nil)
                setSearchingUI(isSearching: false)
                Task{[weak self] in
                    guard let self else {return}
                    await self.weatherViewModel.fetchWeather(for: coordinate)
                }
        }
    }
    
    private func renderUIKitState(){
        print("This is simply here as proof of the observation library working in UIKit")
    }
    @objc private func cityTextChanged() {
        searchViewModel.cityInput = cityTextField.text ?? ""
    }
    
    private func setSearchingUI(isSearching: Bool) {
        searchButton.isEnabled = !isSearching
        locationButton.isEnabled = !isSearching
    }
    
    private func setError(_ message: String?) {
        guard let message, !message.isEmpty else {
            errorLabel.text = nil
            errorLabel.isHidden = true
            return
        }
        errorLabel.text = message
        errorLabel.isHidden = false
    }
    
    @objc private func didTapSearch() {
        Task{ [weak self] in
            guard let self else {return}
            await self.searchViewModel.search()
        }
    }
    
    @objc private func didTapUseLocation() {
        Task{ [weak self] in
            guard let self else {return}
            await self.weatherViewModel.fetchWeatherUsingLocationIfAuthorized()
            
        }
    }
}
