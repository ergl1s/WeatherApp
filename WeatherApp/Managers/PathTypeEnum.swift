//
//  PathTypeEnum.swift
//  WeatherApp
//
//  Created by Alexander Bibikov on 8.03.21.
//

import Foundation

enum PathType {
  var baseUrl: URL {
    return URL(string: "https://api.openweathermap.org")!
  }
  
  var path: String {
    switch self {
    case let .current(lat: lat, lon: lon, apiKey: apiKey):
      return "/data/2.5/onecall?lat=\(lat)&lon=\(lon)&exclude=minutely,hourly&appid=\(apiKey)"
    }
  }
  
  var request: URLRequest {
    let url = URL(string: path, relativeTo: baseUrl)
    return URLRequest(url: url!)
  }

  case current(lat: String, lon: String, apiKey: String)
}
