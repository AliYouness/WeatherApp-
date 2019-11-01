//
//  WeatherAppTests.swift
//  WeatherAppTests
//
//  Created by Ali Youness on 10/25/19.
//  Copyright © 2019 Ali Youness. All rights reserved.
//

import XCTest
@testable import WeatherApp

class WeatherAppTests: XCTestCase {
    
    var weatherModel: WeatherStruct?
    let networkManager =  RestAPI()
    override func setUp() {
        super.setUp()
        //httpSession = URLSession(configuration: .default)
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        weatherModel =  nil
        super.tearDown()
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertEqual(weatherModel?.main.temp, 50, " Temp is too high")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testValidCallToiTunesGetsHTTPStatusCode200()
    {
        
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
}
