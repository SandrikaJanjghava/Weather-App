//
//  NetworkManager.swift
//  Weather App
//
//  Created by Sandro janjghava on 11/9/20.
//

import Foundation

protocol WeatherNetworkManagerType {
    func fetchWeatherData(with latitude: Double, and longitude: Double, success: @escaping (Result) -> Void, fail: @escaping (String) -> Void)
}

class WeatherNetworkManager: WeatherNetworkManagerType {
    
    private let network: Network
    
    init(using network: Network) {
        self.network = network
    }
    
    func fetchWeatherData(with latitude: Double, and longitude: Double, success: @escaping (Result) -> Void, fail: @escaping (String) -> Void) {
        guard var urlComps = URLComponents(string: NetworkConstants.baseUrl) else { return }
        let queryItems = [URLQueryItem(name: NetworkKeys.apiKey, value: NetworkValues.apiKey),
                          URLQueryItem(name: NetworkKeys.latitude, value: String(latitude)),
                          URLQueryItem(name: NetworkKeys.longitude, value: String(longitude)),
                          URLQueryItem(name: NetworkKeys.units, value: String(NetworkValues.metric))]
        urlComps.queryItems = queryItems
        guard let result = urlComps.url else {
            return
        }
        self.network.getWeather(with: result, type: Result.self) { result in
            var sorted = result
            sorted.sortHourlyArray()
            sorted.sortDailyArray()
            success(sorted)
        } errorMessage: { errorMessage in
            fail(errorMessage)
        }
    }
}

extension WeatherNetworkManager {
    struct NetworkKeys {
        static var latitude = "lat"
        static var longitude = "lon"
        static var units = "units"
        static var apiKey = "appid"
    }
    
    struct NetworkValues {
        static var metric = "metric"
        static var apiKey = "fc08a1d847ce8997799b423601c1c8b3"
    }
}
