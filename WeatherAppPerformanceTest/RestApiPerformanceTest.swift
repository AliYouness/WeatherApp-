//
//  RestApiPerformanceTest.swift
//  WeatherAppTests
//
//  Created by Ali Youness on 10/30/19.
//  Copyright © 2019 Ali Youness. All rights reserved.
//

import XCTest
@testable import WeatherApp
class RestApiPerformanceTest: XCTestCase {
    
    let networkManager = RestAPI()
    var httpSession: URLSession!
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()
        httpSession = URLSession(configuration: .default)
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        httpSession = nil
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testMakeWeatherAPIRequest() {
        let promise = expectation(description: "Status code: 200")
        networkManager.getWeatherData(lat: "37.785834", lon: "-122.406417") { (result) in
            switch result {
            case .success(let weatherModel):
                self.weatherModel = weatherModel
                promise.fulfill()
                print(weatherModel)
            case .failure(let error):
                XCTFail("Error: \(error.localizedDescription)")
                print("Error \(error.localizedDescription)")
                return
                
            }
        }
    }
    
    func testCityWeatherAPICompletes() {

         
           networkManager.getWeatherDataByCity(city:"Beirut"){ (result) in
                switch result {
                case .success(let weatherModel):
                    self.weatherModel = weatherModel
                    promise.fulfill()
                    print(weatherModel)
                case .failure(let error):
                    XCTFail("Error: \(error.localizedDescription)")
                    XCTAssertNil(error)
                    print("Error \(error.localizedDescription)")
                    return
                    
                }
            }
    }
    
}
