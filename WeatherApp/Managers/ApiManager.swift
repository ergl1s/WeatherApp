//
//  ApiClient.swift
//  WeatherApp
//
//  Created by Alexander Bibikov on 2.03.21.
//

import Foundation
import CoreLocation

class ApiManager {
  func getWeather(location: CLLocation?, completion: @escaping (Result<WeatherResponse, Error>) -> ()) {
    let session = URLSession.shared
    
    guard let lat = location?.coordinate.latitude, let lon = location?.coordinate.longitude else {
      completion(.failure(ApiError.noLocation))
      return
    }
    
    let urlRequest = PathType.current(lat: String(lat), lon: String(lon), apiKey: AppConstants.apiKey).request
    
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
