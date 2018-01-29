//
//  IssueSampleView.swift
//  SmartCity
//
//  Created by Salim Braksa on 1/29/18.
//  Copyright © 2018 Hidden Founders. All rights reserved.
//

import UIKit
import SDWebImage

class IssueSampleView: UIView {
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var gradientView: UIView!
    
    private var gradientLayer: CALayer?
    
    static func instantiate() -> IssueSampleView {
        let name = String(describing: IssueSampleView.self)
        return Bundle.main.loadNibNamed(name, owner: nil, options: nil)?.first as! IssueSampleView
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        gradientView.backgroundColor = UIColor.clear
        setupGradientLayer()
    }
    
    func configure(using sample: IssueSample) {
        self.descriptionLabel.text = sample.description
        self.imageView.sd_setImage(with: URL(string: sample.image))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupGradientLayer()
    }
    
    private func setupGradientLayer() {
        self.gradientLayer?.removeFromSuperlayer()
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.withAlphaComponent(0.7).cgColor]
        gradientLayer.locations = [0, 0.9]
        gradientView.layer.addSublayer(gradientLayer)
        self.gradientLayer = gradientLayer
    }
    
}

