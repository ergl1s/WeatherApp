//
//  ApiClient.swift
//  WeatherApp
//
//  Created by Alexander Bibikov on 2.03.21.
//

import Foundation
import CoreLocation

enum ApiError: Error {
  case noData
}

protocol ApiClient {
  func getWeather(location: CLLocation?, completion: @escaping (Result<WeatherResponse, Error>) -> ())
}

class ApiClientImplementation: ApiClient {
  var lat : Double = 0
  var lon : Double = 0
  
  func getWeather(location: CLLocation?, completion: @escaping (Result<WeatherResponse, Error>) -> ()) {
    let session = URLSession.shared
    
    lat = Double(location!.coordinate.longitude)
    lon = Double(location!.coordinate.longitude)
  
    
    let url = URL(string: "https://api.openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(lon)&exclude=minutely,hourly&appid=4e81baace841c3ff4ca0b7fb49aedd2e")
    let urlRequest = URLRequest(url: url!)
    let dataTask = session.dataTask(with: urlRequest as URLRequest, completionHandler: { data, response, error in
      guard let data = data else {
        completion(.failure(ApiError.noData))
        return
      }
      do {
        let decoder = JSONDecoder()
        let response = try decoder.decode(WeatherResponse.self, from: data)
        completion(.success(response))
      } catch(let error) {
        print(error)
        completion(.failure(error))
      }
    })
    dataTask.resume()
  }
}
