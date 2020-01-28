
import Foundation
import UIKit

extension UIViewController {
    
    private static var LayerName: String {
        return "ConfettiRain"
    }

    public func startConfettiRain() {

        let particleEmitter = CAEmitterLayer()
        particleEmitter.name = UIViewController.LayerName

        particleEmitter.emitterPosition = CGPoint(x: view.center.x, y: -96)
        particleEmitter.emitterShape = "line"
        particleEmitter.emitterSize = CGSize(width: view.frame.size.width, height: 1)

        let red = makeEmitterCell(color: UIColor.red)
        let green = makeEmitterCell(color: UIColor.green)
        let blue = makeEmitterCell(color: UIColor.blue)
        let yellow = makeEmitterCell(color: UIColor.yellow)

        particleEmitter.emitterCells = [red, green, blue, yellow]
        
        view.layer.addSublayer(particleEmitter)
        
        particleEmitter.opacity = 1
        let fadeAnimation = CABasicAnimation(keyPath:"opacity")
        fadeAnimation.duration = 1.1
        fadeAnimation.fromValue = 0
        fadeAnimation.toValue = 1
        particleEmitter.add(fadeAnimation, forKey:"animateOpacity")
    }
    
    public func stopConfettiRain() {
        
        guard let particleEmitter = view.layer.sublayers?.first(where: { $0.name == UIViewController.LayerName }) else {
            return
        }
        
        CATransaction.begin()
        let fadeAnimation = CABasicAnimation(keyPath:"opacity")
        fadeAnimation.duration = 0.5
        fadeAnimation.fromValue = 1
        fadeAnimation.toValue = 0
        fadeAnimation.isRemovedOnCompletion = false
        
        CATransaction.setCompletionBlock {
            particleEmitter.opacity = 0
            particleEmitter.removeFromSuperlayer()
        }
        
        particleEmitter.add(fadeAnimation, forKey:"animateOpacity")
        
        CATransaction.commit()
    }

    private func makeEmitterCell(color: UIColor) -> CAEmitterCell {
        
        let cell = CAEmitterCell()
        cell.birthRate = 3
        cell.lifetime = 7.0
        cell.lifetimeRange = 0
        cell.color = color.cgColor
        cell.velocity = 200
        cell.velocityRange = 50
        cell.emissionLongitude = CGFloat.pi
        cell.emissionRange = CGFloat.pi / 4
        cell.spin = 2
        cell.spinRange = 3
        cell.scaleRange = 0.5
        cell.scaleSpeed = -0.05

        cell.contents = UIImage.loadImage(name: "confetti")?.cgImage
        
        return cell
    }
}
