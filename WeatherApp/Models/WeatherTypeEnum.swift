//
//  WeatherTypeEnum.swift
//  WeatherApp
//
//  Created by Alexander Bibikov on 7.03.21.
//

import Foundation
import UIKit

enum WeatherType: String {
  case Thunderstorm, Drizzle, Rain, Snow, Clear, Clouds, Wind
  func getImage() -> UIImage {
    var imageName: String
    switch self {
      case .Thunderstorm: imageName = "cloud.bolt.rain.fill"
      case .Drizzle: imageName = "cloud.drizzle.fill"
      case .Rain: imageName = "cloud.rain.fill"
      case .Snow: imageName = "cloud.snow.fill"
      case .Clear: imageName = "sun.max.fill"
      case .Clouds: imageName = "cloud.fill"
      default: imageName = "wind"
    }
    let imageConfig = UIImage.SymbolConfiguration(pointSize: 24)
    return UIImage(systemName: imageName, withConfiguration: imageConfig)!
  }
}
