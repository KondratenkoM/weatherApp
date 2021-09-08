//
//  ViewController.swift
//  wetherapp
//
//  Created by apple on 07.09.2021.
//

import UIKit
import CoreLocation

class ViewController: UIViewController{
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var weatherCondition: UILabel!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var currentDayLabel: UILabel!
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDate()
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.requestLocation()
        
        
        weatherManager.delegate = self
        searchTextField.delegate = self
        
    }
    
    @IBAction func searchButton(_ sender: UIButton) {
        searchTextField.endEditing(true)
    }
    
    @IBAction func locationButton(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    


}


//MARK: - WeatherManager delegate

extension ViewController: WeatherManagerDelegate{
    
    func didUpdateWeather(_ weatherManager: WeatherManager,weather: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = "\(weather.temperatureString)°"
            self.iconImage.image = UIImage(systemName: weather.conditionName)
            self.weatherCondition.text = weather.description
            self.feelsLikeLabel.text = "\(String(format: "%.0f", weather.feelsLike))°"
            self.windSpeedLabel.text = "\(String(format: "%.0f", weather.windSpeed)) m/s"
            self.humidityLabel.text = "\(String(format: "%.0f", weather.humidity))%"
            self.cityLabel.text = weather.cityName
            
            
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
    
}

//MARK: - Core Location delegate
extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(lattitude: lat, longitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }

    
}
//MARK: - Text Field delegate
extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != ""{
            return true
        }else{
            textField.placeholder = "Enter the city name"
            return false
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let city = searchTextField.text {
            weatherManager.fetchWeather(cityName: city)
        }
        searchTextField.text = ""
    }
    
}
//MARK: - Get date
extension ViewController{
    func getDate(){
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        dateLabel.text = formatter.string(from: date)
        
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "EEEE"
        currentDayLabel.text = dayFormatter.string(from: date)
        
        
    }
}


//let date = Date()
//let dateFormatter = DateFormatter()
//dateFormatter.dateFormat = "EEEE"
//let dayInWeek = dateFormatter.string(from: date)


