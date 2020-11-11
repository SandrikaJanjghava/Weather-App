//
//  DailyTableViewCell.swift
//  Weather App
//
//  Created by Sandro janjghava on 11/7/20.
//

import UIKit
import Kingfisher

class DailyTableViewCell: UITableViewCell {

    // MARK: - IBOutlets
    @IBOutlet private weak var temperatureLbl: UILabel!
    @IBOutlet private weak var timeLbl: UILabel!
    @IBOutlet private weak var descriptionLbl: UILabel!
    @IBOutlet private weak var testImage: UIImageView!
    
    func fillCell(with item: Hourly) {
        guard let weather = item.weather.first else { return }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let dateStr = dateFormatter.string(from: Date(timeIntervalSince1970: item.dt))
        self.temperatureLbl.convertTemp(temp: item.temp, from: .celsius, to: .celsius)
        self.timeLbl.text = dateStr
        self.descriptionLbl.text = weather.description.capitalizingFirstLetter()
        guard let url = weather.iconUrl else { return }
        DispatchQueue.global(qos: .background).async {
            let resource = ImageResource(downloadURL: url)
            KingfisherManager.shared.retrieveImage(with: resource, options: nil, progressBlock: nil) { result in
                switch result {
                case .success(let value):
                    DispatchQueue.main.async {
                        self.testImage.image = value.image
                    }
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
        }
    }
    
    private func addCelsius() {
        guard let temperature = self.temperatureLbl.text?.toDouble() else { return }
        let measurement = Measurement(value: temperature, unit: UnitTemperature.celsius)
        
        let measurementFormatter = MeasurementFormatter()
        measurementFormatter.unitStyle = .short
        measurementFormatter.numberFormatter.maximumFractionDigits = 0
        measurementFormatter.unitOptions = .temperatureWithoutUnit

        self.temperatureLbl.text! += measurementFormatter.string(from: measurement)
    }
}
