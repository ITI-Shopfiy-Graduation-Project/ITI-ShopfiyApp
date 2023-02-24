//
//  ViewHelper.swift
//  ITI-Shopfiy
//
//  Created by ahmed on 20/02/2023.
//

import UIKit
@IBDesignable extension UIView {
    
    @IBInspectable var shadowColor: UIColor? {
        set {
            layer.shadowColor = newValue?.cgColor
        }
        get {
            guard let color = layer.shadowColor else {
                return nil
            }
            return UIColor(cgColor: color)
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat {
        set {
            layer.shadowOpacity = 1
            layer.shadowOffset = .zero
            //layer.shadowRadius = newValue
            layer.shadowPath = UIBezierPath(rect: layer.bounds).cgPath
                layer.shouldRasterize = true
            clipsToBounds = newValue > 0
        }
        get {
            return layer.shadowRadius
        }
    }
    
    @IBInspectable var shadowSize: CGSize {
        set {
            layer.shadowOffset = newValue
        }
        get {
            return layer.shadowOffset
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        set {
            layer.borderColor = newValue?.cgColor
        }
        get {
            guard let color = layer.borderColor else {
                return nil
            }
            return UIColor(cgColor: color)
        }
    }
    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
            clipsToBounds = newValue > 0
        }
        get {
            return layer.cornerRadius
        }
    }
}
