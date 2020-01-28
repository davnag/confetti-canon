//
//  ConfettiCell.swift
//  ConfettiCanon
//
//  Created by David Jonsén on 2020-01-28.
//

import UIKit

internal class ConfettiCell: CAEmitterCell {
    
    var colorize: Bool = true {
        didSet {
            setupColor()
        }
    }
    
    init(velocity: CGFloat, emissionLongitude: CGFloat) {
        super.init()
        setupCell()
        setupColor()
        
        self.velocity = velocity
        self.velocityRange = floor(velocity / 10)
        
        self.emissionLongitude = emissionLongitude
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ConfettiCell {

    private func setupCell() {
        
        let cell = self
        
        cell.contents = UIImage.loadImage(name: "confetti")?.cgImage

        cell.name = "confetti"
        cell.birthRate = 0
        cell.lifetime = 7
        cell.lifetimeRange = 2

        cell.alphaSpeed = 4.5
        cell.alphaRange = 0.5

        cell.scale = 0.5
        cell.scaleRange = 0.5
        cell.scaleSpeed = 0.1

        cell.speed = 0.1

        cell.spin = CGFloat.pi
        cell.spinRange = CGFloat.pi/2

        cell.emissionRange = CGFloat.pi/12

        cell.yAcceleration = 180
    }
    
    private func setupColor() {
        
        let cell = self
        
        if colorize {
            cell.blueRange = 1.5
            cell.blueSpeed = 0
            cell.redRange = 1.5
            cell.redSpeed = 0
            cell.greenRange =  1.5
            cell.greenSpeed = 0
        } else {
            cell.blueRange = 0
            cell.blueSpeed = 0
            cell.redRange = 0
            cell.redSpeed = 0
            cell.greenRange = 0
            cell.greenSpeed = 0
        }
    }
}
