
import UIKit
import QuartzCore

public class PartyCanon: UIView {

    public var location: CGPoint = .zero {
        didSet {
            emitter?.emitterPosition = location
        }
    }

    private var emissionLongitude: CGFloat = -CGFloat.pi / 2  //Up
    
    public var target: CGPoint = .zero {
        didSet {

            let targetRadians = self.pointPairToBearingRadians(startingPoint: location, endingPoint: target)
            emissionLongitude = targetRadians
        }
    }

    public var velocity: CGFloat = 0 {
        didSet {
            self.emitter?.setValue(NSNumber(value: Double(self.velocity)), forKeyPath: "emitterCells.confetti.velocity")
        }
    }

    public var amount: Double = 0
    public var colorize: Bool = true

    var particleImage: UIImage?

    private var emitter: CAEmitterLayer?

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
}

extension PartyCanon {

    private func setupView() {
        backgroundColor = .clear
        isUserInteractionEnabled = false
        reset()
    }
}

extension PartyCanon {

    public func reset() {

        location = CGPoint(x: frame.midX, y: frame.maxY)
        target = CGPoint(x: frame.minX, y: frame.maxY)

        velocity = 300
        amount = 500
    }

    public func shoot() {

        let emitter = CAEmitterLayer()
        emitter.emitterPosition = location
        emitter.emitterSize = CGSize(width: 20, height: 20)
        
        emitter.emitterMode = "surface"
        emitter.emitterShape = "rectangle"
        //emitter.emitterMode = .surface
        //emitter.emitterShape = .rectangle
        emitter.speed = 1.75

        layer.addSublayer(emitter)

        emitter.emitterCells = [ConfettiCell(velocity: velocity, emissionLongitude: emissionLongitude)]

        emitter.beginTime = CACurrentMediaTime()
        emitter.setValue(NSNumber(value: self.amount), forKeyPath: "emitterCells.confetti.birthRate")

        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
            emitter.setValue(NSNumber(value: 0), forKeyPath: "emitterCells.confetti.birthRate")
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(10)) {
            emitter.removeFromSuperlayer()
            emitter.removeAllAnimations()
        }
    }
    
    public func randomParty() {

        velocity = CGFloat(Int.random(in: 120...200))
        amount = Double(Int.random(in: 400...600))

        location = CGPoint(x: Int.random(in: 30...Int(bounds.width - 30)),
                                      y: Int.random(in: 60...Int(bounds.height - 60)))
        target = CGPoint(x: location.x - CGFloat(Int.random(in: -50...50)),
                                    y: location.y - CGFloat(Int.random(in: 50...300)))

        shoot()
    }
    
    public func fireRandomCanon(at location: CGPoint) {

        velocity = CGFloat(Int.random(in: 200...250))
        amount = Double(Int.random(in: 300...600))

        self.location = location
        target = CGPoint(x: location.x - CGFloat(Int.random(in: -50...50)),
                                    y: location.y - CGFloat(Int.random(in: 50...300)))

        shoot()
    }
}

extension PartyCanon {

    private func pointPairToBearingRadians(startingPoint: CGPoint, endingPoint: CGPoint) -> CGFloat {
        let originPoint = CGPoint(x: endingPoint.x - startingPoint.x, y: endingPoint.y - startingPoint.y)
        let bearingRadians = atan2(originPoint.y, originPoint.x)
        return bearingRadians
    }

    override public func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return false
    }
}

extension UIImage {
    
    convenience init(fromBundle name: String) {
        fatalError()
    }

    static func loadImage(name: String) -> UIImage? {
        let podBundle = Bundle(for: PartyCanon.self)
        if let url = podBundle.url(forResource: "ConfettiCanon", withExtension: "bundle") {
            let bundle = Bundle(url: url)
            return UIImage(named: name, in: bundle, compatibleWith: nil)
        }
        return nil
    }
}
