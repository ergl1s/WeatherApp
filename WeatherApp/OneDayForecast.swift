import Foundation

// MARK: - WeatherResponse
struct WeatherResponse: Codable {
    let lat, lon: Double
    let timezone: String
    let timezoneOffset: Int
    let current: Current
    let daily: [Daily]

    enum CodingKeys: String, CodingKey {
        case lat, lon, timezone
        case timezoneOffset = "timezone_offset"
        case current, daily
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
}

// MARK: - Temp
struct Temp: Codable {
    let day, night: Double
}

