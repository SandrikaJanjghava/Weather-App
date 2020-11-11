//
//  LoadingView.swift
//  Weather App
//
//  Created by Sandro janjghava on 11/7/20.
//

import UIKit

class LoadingView: UIView {

    // MARK: - Properties
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    func startAnimating() {
        UIView.animate(withDuration: 0.02, animations: { [weak self] in
            self?.alpha = 1
            self?.backgroundView.alpha = 0.3
        }) { (finished) in
            self.activityIndicator.startAnimating()
        }
    }
}
