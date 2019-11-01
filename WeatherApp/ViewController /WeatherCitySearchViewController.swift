//
//  WeatherCitySearchViewController.swift
//  WeatherApp
//
//  Created by Ali Youness on 10/26/19.
//  Copyright © 2019 Ali Youness. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation


class WeatherCitySearchViewController:UIViewController,UITextFieldDelegate
{
    //Public property
    let locationManager = CLLocationManager()
    let animationsManager = SimpleAnimator()
    
    //UI Element
    @IBOutlet weak var cityWeatherButton: UIButton!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var citeTemp: UILabel!
    @IBOutlet weak var cityName: UILabel!
    
    // MARK: - Injection
    let viewModel = WeatherViewModel(dataService: RestAPI())
    
    var testDataObject: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.cityTextField.delegate = self
        setupViews()
        setupLocationManager()
         view.accessibilityIdentifier = "Weather View"
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
          super.viewWillAppear(animated)
          self.cityTextField.accessibilityIdentifier = "cityWeather"
          self.citeTemp.accessibilityIdentifier = "cityTemp"
          self.cityName.accessibilityIdentifier = "cityName"
        
          self.citeTemp.accessibilityValue = testDataObject
          self.cityName.accessibilityValue = testDataObject
          self.cityWeatherButton.accessibilityIdentifier = "Search"
    }
    
    func setupViews()
    {
        cityWeatherButton.setCornerRadius(radius: 5)
        cityTextField.setCornerRadius(radius: 5)
        cityTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 0))
        cityTextField.leftViewMode = .always
        self.cityName.layer.opacity = 0
        self.citeTemp.text = "--℃"
        self.cityName.text = "Updating..."
    }
    func setupLocationManager()
    {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
    }
    func  showAlert(message :String )
    {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
              switch action.style{
              case .default:
                    print("default")
              case .cancel:
                    print("cancel")
             default:
                break
            }}))
        self.present(alert, animated: true, completion: nil)
    }

    
    // MARK: - UI Setup
    private func activityIndicatorStart() {
        // Code for show activity indicator view
        // ...
        print("start")
    }
    
    private func activityIndicatorStop() {
        // Code for stop activity indicator view
        // ...
        print("stop")
    }
    
    
    
    /// Calling API
    /// - Parameter sender: <#sender description#>
    @IBAction func updateWeatherByCityTapped(_ sender: UIButton)
    {
        if cityTextField.text?.isEmpty ?? true
        {
            print("textField is empty")
        }
        else
        {
            viewModel.fetchWeatherCity(withCity:  cityTextField.text ?? "")
            
            viewModel.updateLoadingStatus = {
                let _ = self.viewModel.isLoading ? self.activityIndicatorStart() : self.activityIndicatorStop()
            }
            
            viewModel.showAlertClosure = {
            DispatchQueue.main.async {
                if let error = self.viewModel.error {
                    print(error.localizedDescription)
                    DispatchQueue.main.async{
                        self.showAlert(message:error.localizedDescription)
                    }
                }
              }
            }
            
            viewModel.didFinishFetch = {
                  DispatchQueue.main.async {
                self.citeTemp.text = Int(self.viewModel.temperature ?? 0).description + "℃"
                self.cityName.text = self.viewModel.cityName
                }
                
            }
          
        }
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return .lightContent
        }
    }
    
    //Restrict UITextField to accept only Characters
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        return string.rangeOfCharacter(from: CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")) != nil
    }

    

}
extension WeatherCitySearchViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        guard let location = locations.last else { return }
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            print("long = \(location.coordinate.longitude)", "lat = \(location.coordinate.latitude)")
            let latitude = location.coordinate.latitude.description
            let longitude = location.coordinate.longitude.description
            viewModel.fetchWeather(withLong: longitude, withLat: latitude)
            
            viewModel.updateLoadingStatus = {
                let _ = self.viewModel.isLoading ? self.activityIndicatorStart() : self.activityIndicatorStop()
            }
            
            viewModel.showAlertClosure = {
                if let error = self.viewModel.error {
                    print(error.localizedDescription)
                    DispatchQueue.main.async{
                      self.showAlert(message:error.localizedDescription)
                    }
                }
            }
            
            viewModel.didFinishFetch = {
                DispatchQueue.main.async {
                    self.citeTemp.text = Int(self.viewModel.temperature ?? 0).description + "℃"
                    self.cityName.text = self.viewModel.cityName
                 }
            }

        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}


