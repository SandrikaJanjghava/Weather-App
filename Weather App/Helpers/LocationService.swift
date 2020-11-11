//
//  LocationService.swift
//  Weather App
//
//  Created by Sandro janjghava on 11/7/20.
//

import CoreLocation
import Foundation

public enum LocationStatus {
    case locationAvailable
    case locationNotAvailable
    case locationError(Error?)
}

public enum GeocoderType {
    case success(String?)
    case fail(String?)
}

class LocationService {
    
    private let geoCoder = CLGeocoder()
    private var geocodeType: GeocoderType?
    private let locale = Locale(identifier: "ka")
    
    func getLocationName(from location: CLLocation, completion: @escaping (GeocoderType?) -> Void) {
        self.geoCoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            if let error = error {
                self?.geocodeType = .fail(error.localizedDescription)
                completion(self?.geocodeType)
            } else {
                if let placemark = placemarks?.first {
                    let reversedGeoLocation = ReversedGeoLocation(with: placemark).name
                    self?.geocodeType = .success(reversedGeoLocation)
                    completion(self?.geocodeType)
                }
            }
        }
    }
}

struct ReversedGeoLocation {
    let name: String
    let streetName: String
    let streetNumber: String
    let city: String
    let state: String
    let zipCode: String
    let country: String
    let isoCountryCode: String
    
    var formattedAddress: String {
        return """
        \(name),
        \(streetNumber) \(streetName),
        \(city), \(state) \(zipCode)
        \(country)
        """
    }
    
    init(with placemark: CLPlacemark) {
        self.name           = placemark.name ?? ""
        self.streetName     = placemark.thoroughfare ?? ""
        self.streetNumber   = placemark.subThoroughfare ?? ""
        self.city           = placemark.locality ?? ""
        self.state          = placemark.administrativeArea ?? ""
        self.zipCode        = placemark.postalCode ?? ""
        self.country        = placemark.country ?? ""
        self.isoCountryCode = placemark.isoCountryCode ?? ""
    }
}
