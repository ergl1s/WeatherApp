//
//  CCLLocation+FetchCity.swift
//  WeatherApp
//
//  Created by Alexander Bibikov on 7.03.21.
//

import Foundation
import CoreLocation

extension CLLocation {
    func fetchCity(completion: @escaping (_ city: String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(self) {completion($0?.first?.locality, $1)}
    }
}
