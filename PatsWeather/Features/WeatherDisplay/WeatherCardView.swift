//
//  W.swift
//  PatsWeather
//
//  Created by Patrick Moscova on 3/2/26.
//

import SwiftUI

struct WeatherCardView : View {
    var body: some View {
        VStack(spacing: 12) {
            Text(K.LabelText.Weather.title)
                .font(.title2)
                .accessibilityIdentifier(K.LabelText.Weather.title)
            Text("SwiftUICard Placeholder")
                .font(.body)
        }
        .padding()
    }
}
