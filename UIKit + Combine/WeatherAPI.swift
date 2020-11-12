//
//  WeatherAPI.swift
//  UIKit + Combine
//
//  Created by Damir Lutfullin on 11.11.2020.
//

import Foundation
import Combine

class WeatherAPI {
    static let shared = WeatherAPI()
    
    private let celsiusCharacters = "ºC"
    private let baseaseURL = "https://api.openweathermap.org/data/2.5/weather"
    private let apiKey = "cf0f31ab062ee5159fbd1c1c41a7057a"
    
    private func getUrl(place: String) -> URL? {
        let queryUrl = URL(string: baseaseURL)!
        let components = URLComponents(url: queryUrl, resolvingAgainstBaseURL: true)
        guard var urlComponents = components else { return nil }
        urlComponents.queryItems = [URLQueryItem(name: "appid", value: apiKey),
                                    URLQueryItem(name: "q", value: place),
                                    URLQueryItem(name: "units", value: "metric")]
        return urlComponents.url
    }

    func fetchWeather (city: String?) -> AnyPublisher<WeatherDetail, Never> {
        guard let url = getUrl(place: city ?? "") else {
            return Just(WeatherDetail.placeholder).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map {$0.data }
            .decode(type: WeatherDetail.self, decoder: JSONDecoder())
            .catch { error in Just(WeatherDetail.placeholder) }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
}
