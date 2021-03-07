//
//  ApiClient.swift
//  WeatherApp
//
//  Created by Alexander Bibikov on 2.03.21.
//

import Foundation
import CoreLocation

enum ApiError: Error {
  case noData, noResponse, errorFromServer
  func getTextOfError() -> String {
    var textOfError: String
    switch self {
    case .errorFromServer: textOfError = "Error from Server"
    case .noData: textOfError = "Error with Data"
    case .noResponse: textOfError = "Error with Resposne"
    }
    return textOfError
  }
}

class ApiManager {
  var lat : Double = 0
  var lon : Double = 0
  
  func getWeather(location: CLLocation?, completion: @escaping (Result<WeatherResponse, Error>) -> ()) {
    let session = URLSession.shared
    
    lat = Double(location!.coordinate.longitude)
    lon = Double(location!.coordinate.longitude)
    
    let url = URL(string: "https://api.openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(lon)&exclude=minutely,hourly&appid=4e81baace841c3ff4ca0b7fb49aedd2e")
    let urlRequest = URLRequest(url: url!)
    let dataTask = session.dataTask(with: urlRequest as URLRequest, completionHandler: { data, response, error in
      if let error = error {
        completion(.failure(error))
        return
      }
      
      guard let HTTPResponse = response as? HTTPURLResponse else {
        completion(.failure(ApiError.noResponse))
        return
      }
      
      guard let data = data else {
        completion(.failure(ApiError.noData))
        return
      }
      
      switch HTTPResponse.statusCode {
      case 200...299:
        do {
          let decoder = JSONDecoder()
          let response = try decoder.decode(WeatherResponse.self, from: data)
          completion(.success(response))
        } catch(let error) {
          completion(.failure(error))
        }
      default:
        completion(.failure(ApiError.errorFromServer))
      }
    })
    dataTask.resume()
  }
}
