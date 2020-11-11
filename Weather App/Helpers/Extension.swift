//
//  Extension.swift
//  Weather App
//
//  Created by Sandro janjghava on 11/7/20.
//

import UIKit


extension UIStoryboard {
    func instantiate<T>() -> T {
        return instantiateViewController(withIdentifier: String(describing: T.self)) as! T
    }
    static let main = UIStoryboard(name: "Main", bundle: nil)
}

extension UILabel {
    @IBInspectable public var shouldAdjustFontSizeToFitDevice : Bool { get { return false } set { if(newValue) { self.adjustsFontSizeToFitDevice() } } }
    
    public func adjustsFontSizeToFitDevice() {
        if let f = self.font {
            self.font = UIFont(name: f.fontName, size: f.pointSize * Constants.screenFactor)
        }
    }
    
    func convertTemp(temp: Double, from inputTempType: UnitTemperature, to outputTempType: UnitTemperature) {
        let measurement = MeasurementFormatter()
        measurement.numberFormatter.maximumFractionDigits = 0
        measurement.unitOptions = .providedUnit
        let input = Measurement(value: temp, unit: inputTempType)
        let output = input.converted(to: outputTempType)
        self.text = measurement.string(from: output)
    }
}

extension NSLayoutConstraint {
    @IBInspectable public var shouldAdjustConstantToFitDevice : Bool { get { return false } set { if(newValue) { self.constant *= Constants.screenFactor } } }
}

extension UIViewController {
    func startLoading() {
        let loadingView = LoadingView.fromNib() as! LoadingView
        loadingView.tag = 1001
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(loadingView)
        NSLayoutConstraint.activate([
            loadingView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
            loadingView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
            loadingView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0),
            loadingView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0)
        ])
        loadingView.startAnimating()
    }
    
    func stopLoading() {
        self.view.viewWithTag(1001)?.removeFromSuperview()
    }
}

extension UIView {
    @discardableResult static func fromNib<T : UIView>() -> T? {
        let bundle = Bundle(for: self)
        let nibName = String(describing: self)
        let nib = bundle.loadNibNamed(nibName, owner: nil, options: nil)
        
        return nib?.first as? T
    }
    
    func cornerRadius(corner: CGFloat) {
        self.layer.cornerRadius = corner
        self.layer.masksToBounds = true
    }
    
    func addDashedBorder() {
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor.lightGray.cgColor
        shapeLayer.lineWidth = 2 * Constants.screenFactor
        shapeLayer.lineDashPattern = [2,3]
        
        let path = CGMutablePath()
        path.addLines(between: [CGPoint(x: 0, y: 0),
                                CGPoint(x: self.frame.width, y: 0)])
        shapeLayer.path = path
        layer.addSublayer(shapeLayer)
    }
    
    func removeSublayer() {
        self.layer.sublayers?.removeLast()
        self.addDashedBorder()
    }
}

extension String {
    func toDouble() -> Double? {
        return NumberFormatter().number(from: self)?.doubleValue
    }
    
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}

extension Date {
    var millisecondsSince1970: Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    init(milliseconds: Int) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds / 1000))
    }
    
    func onlyDate() -> Date {
        guard let date = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: self)) else {
            fatalError("Failed to strip time from Date object")
        }
        return date
    }
    
    var weekdayOrdinal: Int {
        return Calendar.current.component(.weekday, from: self)
    }
    
    var prettyTimesTamp: Date {
        let userCalendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.year = userCalendar.component(.year, from: self)
        dateComponents.month = userCalendar.component(.month, from: self)
        dateComponents.day = userCalendar.component(.day, from: self)
        dateComponents.timeZone = TimeZone(abbreviation: "UTC")
        return userCalendar.date(from: dateComponents)!
    }
}



