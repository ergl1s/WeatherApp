//
//  ApiErrorEnum.swift
//  WeatherApp
//
//  Created by Alexander Bibikov on 7.03.21.
//

import Foundation

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
