//
//  CurrentWeatherCollectionViewCell.swift
//  Weather App
//
//  Created by Sandro janjghava on 11/7/20.
//

import UIKit

class CurrentWeatherCollectionViewCell: UICollectionViewCell {
    
}

class CustomLayout: UICollectionViewFlowLayout {

    private let cellSpacing: CGFloat = 30 * Constants.screenFactor

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        if let attributes = super.layoutAttributesForElements(in: rect) {
            for (index, attribute) in attributes.enumerated() {
                if index == 0 { continue }
                let prevLayoutAttributes = attributes[index - 1]
                let origin = prevLayoutAttributes.frame.maxX
                if origin + cellSpacing + attribute.frame.size.width < self.collectionViewContentSize.width {
                    attribute.frame.origin.x = origin + cellSpacing
                }
            }
            return attributes
        }
        return nil
    }
}
