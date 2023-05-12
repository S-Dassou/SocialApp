//
//  PrimaryButton.swift
//  SocialApp
//
//  Created by shafique dassu on 11/05/2023.

import Foundation
import UIKit

@IBDesignable
class PrimaryButton: UIButton  {
    
    @IBInspectable
    var cornerRadius: CGFloat = 6 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable
    var buttonColor: UIColor = UIColor.orange {
        didSet {
            backgroundColor = buttonColor
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupView()
    }
    
    func setupView() {
        backgroundColor = UIColor.orange
        titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        titleLabel?.textColor = UIColor.white
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = cornerRadius
        
    }
}
