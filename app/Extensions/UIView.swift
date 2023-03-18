//
//  UIView.swift
//  DownloadProgress
//
//  Created by Stan Trujillo on 13/08/2023.
//

import UIKit

extension UIView {
    func constrainToSuperView(margin: CGFloat = 0.0) {
        constrainVerticalsToSuperview(margin: margin)
        constrainHorizontalsToSuperview(margin: margin)
    }
    
    func constrainVerticalsToSuperview(margin: CGFloat = 0.0) {
        guard let superview else { assertionFailure(); return }
        self.topAnchor.constraint(equalTo: superview.topAnchor, constant: margin).isActive = true
        self.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -margin).isActive = true
    }
    
    func constrainVerticalsToSafeSuperview(margin: CGFloat = 0.0) {
        guard let superview else { assertionFailure(); return }
        self.topAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.topAnchor, constant: margin).isActive = true
        self.bottomAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.bottomAnchor, constant: -margin).isActive = true
    }
    
    func constrainHorizontalsToSuperview(margin: CGFloat = 0.0) {
        guard let superview else { assertionFailure(); return }
        self.leftAnchor.constraint(equalTo: superview.leftAnchor, constant: margin).isActive = true
        self.rightAnchor.constraint(equalTo: superview.rightAnchor, constant: -margin).isActive = true
    }
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        layer.cornerRadius = radius
        layer.maskedCorners = CACornerMask(rawValue: corners.rawValue)
    }
    
    func addBorder(color: UIColor, radius: CGFloat = 15, width: CGFloat = 1) {
        self.layer.borderColor = color.cgColor
        self.layer.cornerRadius = radius
        self.layer.borderWidth = width
    }
}
