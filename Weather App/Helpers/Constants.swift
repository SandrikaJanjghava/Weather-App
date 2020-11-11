//
//  Constants.swift
//  Weather App
//
//  Created by Sandro janjghava on 11/7/20.
//

import UIKit

open class Constants {
    
    public init () {}

    public static var screenFactor: CGFloat {
        return UIScreen.main.bounds.size.width / 375
    }
}

struct WeatherConstants {
    static var speed = " km/h"
    static var percentage = " %"
    static var hpa = " hPa"
}
