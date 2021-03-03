//
//  ApiClient.swift
//  WeatherApp
//
//  Created by Alexander Bibikov on 2.03.21.
//

import Foundation
enum ApiError: Error {
  case noData
}

protocol ApiClient {
  func getWeather(completion: @escaping (Result<WeatherResponse, Error>) -> ())
}

class ApiClientImplementation: ApiClient {
  func getWeather(completion: @escaping (Result<WeatherResponse, Error>) -> ()) {
    let session = URLSession.shared
    let url = URL(string: "https://api.openweathermap.org/data/2.5/onecall?lat=53.441792&lon=27.037689&exclude=minutely,hourly&appid=4e81baace841c3ff4ca0b7fb49aedd2e")
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
