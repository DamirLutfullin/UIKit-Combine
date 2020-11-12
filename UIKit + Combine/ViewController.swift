//
//  ViewController.swift
//  UIKit + Combine
//
//  Created by Damir Lutfullin on 11.11.2020.
//

import UIKit
import Combine

class ViewController: UIViewController {
    
    @IBOutlet var cityLabel: UILabel!
    @IBOutlet var textField: UITextField!
    
    private let weatherViewModel = TempViewModel()
    
    var cancelableSet = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bining()
    }
    
    func bining() {
        textField.textPublisher
            .assign(to: \.city, on: weatherViewModel)
            .store(in: &cancelableSet)
        
        self.weatherViewModel.$currentWeather
            .sink { [weak self] (currentWeather) in
                self?.cityLabel.text = currentWeather.main?.temp != nil ? " температура: \((currentWeather.main?.temp!.description)!)" : ""
            }
            .store(in: &cancelableSet)
    }
}

extension UITextField {
    var textPublisher: AnyPublisher <String, Never> {
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: self)
            .compactMap{$0.object as? UITextField}
            .map{$0.text ?? ""}
            .eraseToAnyPublisher()
    }
}

