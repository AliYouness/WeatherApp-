//
//  Constants.swift
//  WeatherApp
//
//  Created by Ali Youness on 10/26/19.
//  Copyright © 2019 Ali Youness. All rights reserved.
//

import Foundation
enum CellIdentifiers {
    static let dayTableViewCell          = "DayTableViewCell"
    static let weatherCollectionViewCell = "WeatherCollectionViewCell"
}

enum NibFile {
    static let dayTableViewCell          = "DayTableViewCell"
    static let weatherCollectionViewCell = "WeatherCollectionViewCell"
}


struct Config {
    static let APIKey = "71274958d99855d4efc83eda8e6e2b42"
    static let BaseURL = "https://api.openweathermap.org/data/2.5/forecast"
    //https://api.openweathermap.org/data/2.5/forecast//
    //http://api.openweathermap.org/data/2.5/weather?q=Atlanta,us
    //http://api.openweathermap.org/data/2.5/weather?q=Atlanta,us?&APPID={API Key}
}
