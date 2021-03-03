//
//  File.swift
//  WeatherApp
//
//  Created by Alexander Bibikov on 3.03.21.
//

import Foundation

func getDayOfWeek(dtFormat:Int) -> String {
  let date = Date(timeIntervalSince1970: Double(dtFormat))
  let dateFormatter = DateFormatter()
  dateFormatter.timeZone = .current
  dateFormatter.dateFormat = "EEEE"
  return dateFormatter.string(from: date)
}

