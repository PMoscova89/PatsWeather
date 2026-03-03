//
//  LocationDescriptor.swift
//  PatsWeather
//
//  Created by Patrick Moscova on 3/2/26.
//

struct LocationDescriptor: Equatable {
    let city: String
    let stateCode: String?
    let countryCode: String
    let latitude: Double?
    let longitude: Double?
    
    init(city: String,
         stateCode: String?,
         countryCode: String = "US",
         latitude: Double?,
         longitude: Double?) {
        self.city = city
        self.stateCode = stateCode
        self.countryCode = countryCode
        self.latitude = latitude
        self.longitude = longitude
    }
}

extension LocationDescriptor {
    var displayName: String {
        if let stateCode, !stateCode.isEmpty {
            return "\(city), \(stateCode)"
        }else {
            return city
        }
    }
}
