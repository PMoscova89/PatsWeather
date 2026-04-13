# PatsWeather

A SwiftUI weather application built as a take-home coding challenge — and a deliberate opportunity to get hands-on with Apple's `Observation` framework in a real project context.

## Overview

Built with MVVM-C architecture using UIKit and SwiftUI in tandem. The search screen lives in UIKit; the weather card renders in SwiftUI. A `Coordinator` owns navigation, `ViewModels` own state, and services are injected — not constructed inline.

The `@Observable` macro replaces the older `ObservableObject` + `@Published` pattern throughout the view model layer, keeping state management leaner and dependency tracking intentional via `@ObservationIgnored` on services and internal infrastructure.

## Features

- Search weather by city name or current GPS location
- Async/await networking with structured error handling
- Reusable HTTP client and response validation pipeline
- State-driven UI updates with real-time weather data presentation
- Orientation-adaptive layout using `ViewThatFits` and size class observation
- Centralized string and accessibility identifier constants (`K` namespace)
- API key management via environment configuration — no secrets committed
- Unit tests for `SearchViewModel` and `WeatherViewModel`
- UI test suite with mock injection via launch arguments

## Architecture

- **MVVM-C** — ViewModels own state, Coordinators own navigation, Views own nothing they shouldn't
- **`@Observable`** — Swift Observation framework used in place of Combine-based state
- **Dependency Injection** — all services passed through initializers, no singletons
- **UIKit + SwiftUI hybrid** — `SearchViewController` in UIKit hosting a SwiftUI `WeatherCardView`
- **Modular service layer** — `WeatherServiceProtocol` backed by `OpenWeatherService`

## What I Learned

Using `Observation` instead of `ObservableObject` forced me to think more carefully about what *should* trigger UI updates and what shouldn't. `@ObservationIgnored` ended up being the interesting part — decorating services, tasks, and subjects as non-tracked infrastructure made the boundary between "UI state" and "implementation detail" explicit in a way that `@Published` never required.

## Requirements

- Xcode 15+
- iOS 17+
- OpenWeather API key (add to `AppConfiguration.swift`)
