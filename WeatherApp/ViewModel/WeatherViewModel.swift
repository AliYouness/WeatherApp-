//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Ali Youness on 10/31/19.
//  Copyright © 2019 Ali Youness. All rights reserved.
//

import Foundation

class WeatherViewModel {
    
    
    private var currentWeather: WeatherStruct? {
           didSet {
               guard let p = currentWeather else { return }
               self.setupText(with: p)
               self.didFinishFetch?()
           }
       }
       var error: Error? {
           didSet { self.showAlertClosure?() }
       }
       var isLoading: Bool = false {
           didSet { self.updateLoadingStatus?() }
       }
    var cityName: String?
    var temperature: Float?
    var visibility: Float?
    private var dataService: RestAPI?
    // MARK: - Constructor
    init(dataService: RestAPI)
    {
        self.dataService = dataService
    }
    // MARK: - Closures for callback, since we are not using the ViewModel to the View.
     var showAlertClosure: (() -> ())?
     var updateLoadingStatus: (() -> ())?
     var didFinishFetch: (() -> ())?
     
  // MARK: - Network call
    func fetchWeatherCity(withCity city: String)
    {
         self.dataService?.getWeatherDataByCity(city: city){(result) in
            
              switch result
              {
                 case .success(let weatherModel):
                     self.error = nil
                     self.isLoading = false
                     self.currentWeather = weatherModel
                     DispatchQueue.main.async {
                        self.setupText(with: weatherModel)
                       }
                      return
                
                 case .failure(let error):
                    self.error = error
                    self.isLoading = false
                
             }
        }

       }
    func fetchWeather(withLong longitude: String , withLat latitude:String)
    {
            
               self.dataService?.getWeatherData(lat: latitude, lon: longitude){(result) in
                  
                    switch result
                    {
                       case .success(let weatherModel):
                           self.error = nil
                           self.isLoading = false
                           self.currentWeather = weatherModel
                            return
                      
                       case .failure(let error):
                          self.error = error
                          self.isLoading = false
                      
                   }
              }

             }
       // MARK: - UI Logic
       private func setupText(with currentWeather: WeatherStruct)
       {
            self.cityName =  currentWeather.name
            self.temperature = currentWeather.main.temp
       }
}
