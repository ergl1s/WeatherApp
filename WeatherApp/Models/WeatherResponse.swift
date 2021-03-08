import Foundation

// MARK: - WeatherResponse
struct WeatherResponse: Codable {
  let current: Current
  let daily: [Daily]

  enum CodingKeys: String, CodingKey {
      case current, daily
  }
  
  func getCurrentDay() -> String {
    return getDayOfWeek(dtFormat: current.dt)
  }
  
  func getCurrentTemperature() -> String {
    return "\(round(current.temp*10 - 2730)/10)°"
  }
  
  func getCurrentWeather() -> String {
    return current.weather[0].main;
  }
  
  func getCurrentAvgDayTemperature() -> String {
    return daily[0].getAvgDayTemperature()
  }
  
  func getCurrentAvgNightTemperature() -> String {
    return daily[0].getAvgNightTemperature()
  }
}

// MARK: - Current
struct Current: Codable {
  let dt: Int
  let temp: Double
  let weather: [Weather]

  enum CodingKeys: String, CodingKey {
      case dt, temp
      case weather
  }
}

// MARK: - Weather
struct Weather: Codable {
  let main, weatherDescription, icon: String

  enum CodingKeys: String, CodingKey {
      case main
      case weatherDescription = "description"
      case icon
  }
}

// MARK: - Daily
struct Daily: Codable {
  let dt: Int
  let temp: Temp
  let weather: [Weather]

  enum CodingKeys: String, CodingKey {
      case dt, temp, weather
  }
  
  func getAvgDayTemperature() -> String {
    return "\(round(temp.day*10 - 2730)/10)°"
  }
  
  func getAvgNightTemperature() -> String {
    return "\(round(temp.night*10 - 2730)/10)°"
  }
  
  func getWeather() -> String {
    return weather[0].main;
  }
  
  func getDay() -> String {
    return getDayOfWeek(dtFormat: dt)
  }
}

// MARK: - Temp
struct Temp: Codable {
  let day, night: Double
}

