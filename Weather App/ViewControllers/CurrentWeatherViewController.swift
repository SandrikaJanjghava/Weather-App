//
//  CurrentWeatherViewController.swift
//  Weather App
//
//  Created by Sandro janjghava on 11/7/20.
//

import UIKit
import Kingfisher

class CurrentWeatherViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet private weak var currentCity: UILabel!
    @IBOutlet private weak var rainyImageView: UIImageView!
    @IBOutlet private weak var rainyLbl: PaddingLabel!
    @IBOutlet private weak var presipationImageView: UIImageView!
    @IBOutlet private weak var presipationLbl: PaddingLabel!
    @IBOutlet private weak var preasureImageView: UIImageView!
    @IBOutlet private weak var preasureLbl: PaddingLabel!
    @IBOutlet private weak var visibilityImageView: UIImageView!
    @IBOutlet private weak var visibilityLbl: PaddingLabel!
    @IBOutlet private weak var windDirectionImageView: UIImageView!
    @IBOutlet private weak var windDIrectionLbl: PaddingLabel!
    @IBOutlet private weak var currentWeatherLbl: UILabel!
    @IBOutlet private weak var currentWeatherImgView: UIImageView!
    @IBOutlet private var viewArr: [UIView]!
    
    // MARK: - Properties
    private let reuseIdentifier = "CurrentWeatherCollectionViewCell"
    var current: CurrentWeatherType? {
        didSet {
            self.setWeatherText()
        }
    }
    var currentLocation: String? {
        didSet {
            guard self.currentLocation != nil else {
                return
            }
            self.currentCity.text = self.currentLocation
        }
    }
    
    static func load(with current: CurrentWeatherType?, location: String?) -> CurrentWeatherViewController {
        let controller = UIStoryboard.main.instantiate() as CurrentWeatherViewController
        controller.current = current
        controller.currentLocation = location
        return controller
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customization()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) -> Void in
        }, completion: { (UIViewControllerTransitionCoordinatorContext) -> Void in
            if UIDevice.current.orientation.isLandscape {
                self.viewArr.forEach { view in
                    view.removeSublayer()
                }
            } else if UIDevice.current.orientation.isPortrait {
                self.viewArr.forEach { view in
                    view.removeSublayer()
                }
            }
        })
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    // MARK: - Custom Funcs
    private func customization() {
        self.viewArr.forEach { view in
            view.addDashedBorder()
        }
    }
    
    private func setWeatherText() {
        guard let current = self.current?.current else { return }
        self.preasureLbl.text = String(describing: current.pressure).appending(WeatherConstants.hpa)
        let desc = current.weather.first?.description.capitalizingFirstLetter()
        self.currentWeatherLbl.convertTemp(temp: current.temp, from: .celsius, to: .celsius)
        self.currentWeatherLbl.text! += " | \(desc ?? "")"
        self.getImage(icon: current.weather.first?.icon)
        
        let windSpeed = String(current.wind_speed).appending(WeatherConstants.speed)
        let windGust = String(current.wind_deg).appending(WeatherConstants.percentage)
        self.windDIrectionLbl.text = windSpeed
        self.presipationLbl.text = windGust

    }
    
    private func getImage(icon: String?) {
        guard let icon = icon else { return }
        guard let url = URL(string: String(format: NetworkConstants.iconUrl, icon)) else { return }
        let resource = ImageResource(downloadURL: url)
        self.currentWeatherImgView.kf.setImage(with: resource)
    }
    
    private func openShareDialog() {
        let text = "This is some text that I want to share."
        let activityViewController = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook]
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    // MARK: - IBAction
    @IBAction private func shareBtnAction(_ sender: UIButton) {
        self.openShareDialog()
    }
}

