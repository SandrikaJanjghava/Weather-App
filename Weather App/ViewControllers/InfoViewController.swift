//
//  InfoViewController.swift
//  Weather App
//
//  Created by Sandro janjghava on 11/7/20.
//

import UIKit

public enum InfoType: String {
    case noInternet
    case noLocation
}

class InfoViewController: UIViewController {
    
    // MARK: IBOutlets
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var titleLbl: UILabel!
    
    // MARK: Properties
    private var errorMessage: String?
    private var type: InfoType?
    
    static func load(with text: String?, type: InfoType) -> InfoViewController {
        let infoController = UIStoryboard.main.instantiate() as InfoViewController
        infoController.errorMessage = text
        infoController.type = type
        return infoController
    }

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.screenUI()
    }
    
    // MARK: - Custom Funcs
    private func screenUI() {
        self.titleLbl.text = self.errorMessage
        guard var imageName = self.type?.rawValue else { return }
        if #available(iOS 12.0, *) {
            imageName += String(self.traitCollection.userInterfaceStyle.rawValue)
        }
        self.imageView.image = UIImage(named: imageName)
    }
}
