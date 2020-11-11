//
//  TabBarViewController.swift
//  Weather App
//
//  Created by Sandro janjghava on 11/7/20.
//

import UIKit
import CoreLocation

class TabBarViewController: UITabBarController {
    
    // MARK: - Properties
    private let locationService = LocationService()
    private var filteredItems: [Daily] = []
    private var manager: CLLocationManager = CLLocationManager()
    private var currentLocation: CLLocation?
    private var current = CurrentWeatherViewController()
    private var daily = DailyWeatherViewController()
    private var location: String? = nil
    private var result: Result? {
        didSet {
            self.current.current = result
            self.daily.filteredData = result
            self.current.currentLocation = self.location
        }
    }
    
    private var networkManager: WeatherNetworkManagerType!

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addingSwipe()
        self.customization()
        self.checkInternetAndLocation()
        self.checkLocation()
        self.setViewControllers()
    }
    
    
    static func load(withNetwork: Network) -> TabBarViewController {
        let controller = UIStoryboard.main.instantiate() as TabBarViewController
        controller.networkManager = WeatherNetworkManager(using: withNetwork)
        return controller
    }
    
    private func setViewControllers() {
        self.current = CurrentWeatherViewController.load(with: self.result, location: self.location)
        self.daily = DailyWeatherViewController.load(with: self.result)
        self.viewControllers = [self.current, self.daily]
        
        self.selectedIndex = 0
    }
    
    private func addingSwipe() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swiped))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swiped))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipeLeft)
    }
    
    private func customization() {
        self.startLoading()
        self.delegate = self
    }
    
    private func checkInternetAndLocation() {
        guard Reachability.isConnectedToNetwork() else {
            self.loadInfoController(with: "No internet", and: .noInternet)
            return
        }
    }
    
    private func loadInfoController(with text: String?, and infoType: InfoType) {
        let viewController = InfoViewController.load(with: text, type: infoType)
        self.navigationController?.present(viewController, animated: true, completion: nil)
    }
    
    private func loadWeather(usingLon lon: Double, lat: Double, current: String?) {
        self.networkManager.fetchWeatherData(with: lon, and: lat) { [weak self] result in
            self?.result = result
            self?.stopLoading()
            
        } fail: { [weak self] message in
            self?.stopLoading()
            self?.showError(with: message)
        }
    }
    
    private func showError(with message: String?) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alertController, animated: true)
    }
    
    private func checkLocation() {
        self.manager.requestWhenInUseAuthorization()
        if (CLLocationManager.locationServicesEnabled()) {
            self.manager.delegate = self
            self.manager.desiredAccuracy = kCLLocationAccuracyBest
            self.manager.requestWhenInUseAuthorization()
            self.manager.requestLocation()
        }
    }

    @objc func swiped(_ sender: UISwipeGestureRecognizer) {
        guard self.checkSwipe(with: sender) else { return }
        guard let from = self.children[self.selectedIndex].view else { return }
        sender.direction == .left ? (self.selectedIndex += 1) : (self.selectedIndex -= 1)
        guard let toView = self.children[self.selectedIndex].view else { return }
        UIView.transition(from: toView, to: from, duration: 0.3, options: [.transitionCrossDissolve], completion: nil)
    }
    
    private func checkSwipe(with sender: UISwipeGestureRecognizer) -> Bool {
        if self.selectedIndex == 1 && sender.direction != .left {
            return true
        } else if self.selectedIndex == 0 && sender.direction != .right {
            return true
        } else {
            return false
        }
    }
}

// MARK: - UITabBarControllerDelegate
extension TabBarViewController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard let fromView = self.selectedViewController?.view, let toView = viewController.view else {
            return false
        }
        if fromView != toView {
            UIView.transition(from: fromView, to: toView, duration: 0.3, options: [.transitionCrossDissolve], completion: nil)
        }
        return true
    }
}

// MARK: - CLLocationManagerDelegate
extension TabBarViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        self.currentLocation = location
        self.locationService.getLocationName(from: location) { [weak self] geoCodeType in
            switch geoCodeType {
            case .success(let value):
                self?.location = value
                self?.loadWeather(usingLon: location.coordinate.longitude, lat: location.coordinate.latitude, current: value)
            case .fail(let value):
                self?.showError(with: value)
            default:
                break
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {}
}

