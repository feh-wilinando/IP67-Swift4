//
//  Weather.swift
//  IP67-Swift4
//
//  Created by Nando on 11/01/18.
//  Copyright © 2018 Nando. All rights reserved.
//

import UIKit


struct Weather {
    let condition: String
    let temperature: Temperature
    let icon: String
}


struct Temperature {
    let min: Double
    let max: Double
}

struct JsonResponse: Codable {
    let weather: [WeatherDTO]
    let main: TemperatureDTO
    
    func unwrapp() -> Weather {
        let temperature = Temperature(min: main.temp_min, max: main.temp_max)
        let someWeather = weather[0]
        
        return Weather(condition: someWeather.main, temperature: temperature, icon: someWeather.icon)
    }
}

struct WeatherDTO: Codable{
    let main: String
    let icon: String
}

struct TemperatureDTO: Codable {
    let temp_min: Double
    let temp_max: Double
}
