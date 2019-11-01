//
//  WeatherDataModel.swift
//  WeatherApp
//
//  Created by  Евгений on 12/12/2018.
//  Copyright © 2018 LosAnatoly Inc. All rights reserved.
//

import Foundation

class WeatherDataModel {
    
    var temperature : Int = 0
    var condition: Int = 0
    var city : String = ""
    
    func updateWeatherIcon(condition: Int) -> String {
        
        switch condition {
        case 0...300 :
            return "tstorm1"
            
        case 301...500 :
            return "shower3"
            
        case 501...600 :
            return "shower3"
            
        case 601...700 :
            return "snow4"
            
        case 701...771 :
            return "fog"
            
        case 772...799 :
            return "tstorm3"
            
        case 800 :
            return "sunny"
            
        case 801...804 :
            return "cloudy2"
            
        case 900...903, 905...1000  :
            return "tstorm3"
            
        case 903 :
            return "snow4"
            
        case 904 :
            return "sunny"
            
        default :
            return "Cloud-Refresh"
        }
    }
}

struct WeatherStruct : Codable {   //: Codable
    let name: String
    let main: TemparatureData
    let weather: [WeatherData] = []
  
}

struct TemparatureData: Codable{  //: Codable
    let temp: Float
    let tempMin:Float
    let tempMax:Float
}

struct WeatherData: Codable {   //: Codable
    var id: Int
    var main:String
    var description: String
    var icon: String
}






