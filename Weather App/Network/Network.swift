//
//  Network.swift
//  Weather App
//
//  Created by Sandro janjghava on 11/7/20.
//

import Foundation
import Alamofire

struct NetworkConstants {
    
    static var apiKey = "fc08a1d847ce8997799b423601c1c8b3"
    static var iconUrl = "https://openweathermap.org/img/w/%@.png"
    static var baseUrl = "https://api.openweathermap.org/data/2.5/onecall"
    static var latitude = "41.75035761543498"
    static var longitude = "44.78773481355965"
}

class Network {
    
    // MARK: - Properties
    private var baseUrl: URL?
    private let session = URLSession(configuration: .default)
    
    func getWeather<TResponse: Codable>(with url: URL,type: TResponse.Type, success: @escaping (TResponse) -> Void, errorMessage: @escaping (String) -> Void) {
        let task = self.session.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    errorMessage(error.localizedDescription)
                    return
                }
                guard let data = data, let response = response as? HTTPURLResponse else {
                    errorMessage("Invalid data")
                    return
                }
                do {
                    if response.statusCode == 200 {
                        let items = try JSONDecoder().decode(TResponse.self, from: data)
                        success(items)
                    } else {
                        errorMessage("Responce was not 200, it was \(response.statusCode)")
                    }
                } catch {
                    errorMessage(error.localizedDescription)
                }
            }
        }
        task.resume()
    }
}
