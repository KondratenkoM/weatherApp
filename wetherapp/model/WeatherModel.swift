//
//  WeatherModel.swift
//  wetherapp
//
//  Created by apple on 08.09.2021.
//

import Foundation

struct  WeatherModel {
    let conditionId: Int
    let cityName: String
    let temperature: Double
    let description: String
    let feelsLike: Double
    let windSpeed: Double
    let humidity: Double
    
    
    var temperatureString: String {
        return String(format: "%.0f", temperature,"°")
    }
    
    
    
    var conditionName: String {
        switch conditionId {
        case 199...203:
            return "cloud.bolt.rain"
        case 229...233:
            return "cloud.bolt.rain"
        case 209...222:
            return "cloud.bolt"
        case 299...312:
            return "cloud.drizzle"
        case 313...322:
            return "cloud.sleet"
        case 499...512:
            return "cloud.rain"
        case 519...532:
            return "cloud.sleet"
        case 599...632:
            return "cloud.snow"
        case 700...782:
            return "cloud.fog"
        case 800:
            return "sun.max"
        default:
            return "cloud"
        }
    }
    
}
