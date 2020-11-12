//
//  TempViewModel.swift
//  UIKit + Combine
//
//  Created by Damir Lutfullin on 11.11.2020.
//

import Foundation
import Combine

final class TempViewModel: ObservableObject {
    // input вью модель получает город
    @Published var city = "London"
    
    //output вью модель отдает погоду
    @Published var currentWeather = WeatherDetail.placeholder
    
    private var cancelebleSet = Set<AnyCancellable>()
    
    init() {
        // подписываемся на сити
        $city
            // пауза получения велью
            .debounce(for: 0.3, scheduler: RunLoop.main)
            // удаление дубликатов из получаемых подряд значений ( например из двух подряд двоек пройдет только одна, но если будет 2 3 2 то обе)
            .removeDuplicates()
            //
            .flatMap { (city: String) -> AnyPublisher<WeatherDetail, Never> in
                WeatherAPI.shared.fetchWeather(city: city)
            }
            .assign(to: \.currentWeather, on: self)
            .store(in: &cancelebleSet)
    }
    
}
