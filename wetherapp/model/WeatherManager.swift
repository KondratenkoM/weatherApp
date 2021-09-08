//
//  WeatherManager.swift
//  wetherapp
//
//  Created by apple on 08.09.2021.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager,weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager{

    
    
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?&appid=5820f0b94a410ad33d2517db565c4b8a&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    func fetchWeather(lattitude: CLLocationDegrees, longitude: CLLocationDegrees){
        let urlString = "\(weatherURL)&lat=\(lattitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let weather = self.parseJSON(safeData){
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
                
            }
            task.resume()
            
        }
    }
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            let description = decodedData.weather[0].description
            let feelsLike = decodedData.main.feels_like
            let windSpeed = decodedData.wind.speed
            let humidity = decodedData.main.humidity
            
            let weather = WeatherModel(conditionId: id,
                                       cityName: name,
                                       temperature: temp,
                                       description: description,
                                       feelsLike: feelsLike,
                                       windSpeed: windSpeed,
                                       humidity: humidity)
            return weather
            
        }catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
        
    }
    
    //'description', 'feelsLike', 'windSpeed', 'humidity' in call
    
    
}
