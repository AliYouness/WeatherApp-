//
//  WeatherCitySearchViewControllerTest.swift
//  WeatherAppUITests
//
//  Created by Ali Youness on 11/1/19.
//  Copyright © 2019 Ali Youness. All rights reserved.
//

import XCTest

class WeatherCitySearchViewControllerTest: XCTestCase {
    
    var app: XCUIApplication!
    
    let viewModel = WeatherViewModel(dataService: RestAPI())
    //var controller: WeatherCitySearchViewController = UIViewController()
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        app = XCUIApplication()
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()
        
    }
    func testRExisting() {
        app.launch()
        let isDisplayingWeatherView = app.otherElements["Weather View"].exists
        XCTAssertTrue(isDisplayingWeatherView)
        XCTAssertEqual(app.staticTexts.element(boundBy: 0).value as! String, "cityWeather")
        app.terminate()
        XCTAssertEqual(app.staticTexts.element(boundBy: 0).value as! String, "cityTemp")
        app.terminate()
        XCTAssertEqual(app.staticTexts.element(boundBy: 0).value as! String, "cityName")
        app.terminate()
        
        let cityTextField = app.textFields["cityWeather"]
        cityTextField.typeText("Beirut")
        
        cityTextField.tap()
        cityTextField.clearText(andReplaceWith: "VALUE")
        XCTAssertEqual(cityTextField.value as! String, "VALUE", "Text field value is not correct")
        
        // Tap the "Done" button
        app.buttons["Search"].tap()
        // CityTextField should not be empty
        //waitForExpectations(timeout: 5, handler: nil)
        
        
    }
    func  testSearch()
    {
        let userCityTextField = app.textFields["cityWeather"]
        userCityTextField.tap()
        userCityTextField.typeText("Beirut")
        
        //check the equality between module and UI
        //XCTAssertEqual(cellLabelText, "Fourth Row")
        let searchButton = app.buttons["Search"]
        searchButton.tap()
        waitForExpectations(timeout: 5, handler: nil)
        // Since this is an asynchronous network-bound operation, we'll wait for
        // a while for an alert to appear on the screen before
        // performing an assertion
        if(self.viewModel.isLoading == false)
        {
            
            let temp:Float = self.viewModel.temperature ?? 0.0
            XCTAssertEqual(app.staticTexts.element(matching:.any, identifier: "cityTemp").label, temp.stringValue)
            
            let cityName = self.viewModel.cityName
            XCTAssertEqual(app.staticTexts.element(matching:.any, identifier: "cityName").label, cityName)
            
        }
        
    }
    
    func testSearchSucceeded() {

    }
    
    func testSearchFailed() {
    
    }
    override func tearDown() {
        app = nil
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testLaunchPerformance() {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }
    
}

extension XCTestCase {
    func wait(for duration: TimeInterval) {
        let waitExpectation = expectation(description: "Waiting")
        
        let when = DispatchTime.now() + duration
        DispatchQueue.main.asyncAfter(deadline: when) {
            waitExpectation.fulfill()
        }
        
        // We use a buffer here to avoid flakiness with Timer on CI
        waitForExpectations(timeout: duration + 0.5)
    }
}

extension Float {
    
    var stringValue: String {
        
        return String(format: "%.1f", self)
    }
}

extension XCUIApplication {
    // Because of "Use cached accessibility hierarchy"
    func clearCachedStaticTexts() {
        let _ = staticTexts.count
    }
    var isDisplayingAlertForAnalyticsEvent: Bool {
           return otherElements["HELLO_VIEW"].exists
       }
    
    func clearCachedTextFields() {
        let _ = textFields.count
    }
    
    func clearCachedTextViews() {
        let _ = textViews.count
    }
}

extension XCUIElement {
    func deleteAllText() {
        guard let string = value as? String else {
            return
        }
        
        let lowerRightCorner = coordinate(withNormalizedOffset: CGVector(dx: 0.9, dy: 0.9))
        lowerRightCorner.tap()
        let deletes = string.map({ _ in XCUIKeyboardKey.delete.rawValue }).joined(separator: "")
        typeText(deletes)
    }
}
extension XCUIElement {
    func clearText(andReplaceWith newText:String? = nil) {
        tap()
        press(forDuration: 1.0)
        var select = XCUIApplication().menuItems["Select All"]
        
        if !select.exists {
            select = XCUIApplication().menuItems["Select"]
        }
        //For empty fields there will be no "Select All", so we need to check
        if select.waitForExistence(timeout: 0.5), select.exists {
            select.tap()
            typeText(String(XCUIKeyboardKey.delete.rawValue))
        } else {
            tap()
        }
        if let newVal = newText {
            typeText(newVal)
        }
    }
}
