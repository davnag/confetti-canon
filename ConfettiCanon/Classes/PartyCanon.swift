
import UIKit
import QuartzCore

@objc
public class PartyCanon: UIView {

    @objc
    public var location: CGPoint = .zero {
        didSet {
            emitter?.emitterPosition = location
        }
    }

    @objc
    private var emissionLongitude: CGFloat = -CGFloat.pi / 2  //Up
    
    @objc
    public var target: CGPoint = .zero {
        didSet {

            let targetRadians = self.pointPairToBearingRadians(startingPoint: location, endingPoint: target)
            emissionLongitude = targetRadians
        }
    }

    @objc
    public var velocity: CGFloat = 0 {
        didSet {
            self.emitter?.setValue(NSNumber(value: Double(self.velocity)), forKeyPath: "emitterCells.confetti.velocity")
        }
    }

    @objc
    public var amount: Double = 0
    
    @objc
    public var colorize: Bool = true

    @objc
    var particleImage: UIImage?

    private var emitter: CAEmitterLayer?

    @objc
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    @objc
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

    @objc
    public func reset() {

        location = CGPoint(x: frame.midX, y: frame.maxY)
        target = CGPoint(x: frame.minX, y: frame.maxY)

        velocity = 300
        amount = 500
    }

    @objc
    public func fire() {

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
    
    @objc
    public func fireAtRandomLocation() {

        velocity = CGFloat(Int.random(in: 120...200))
        amount = Double(Int.random(in: 400...600))

        location = CGPoint(x: Int.random(in: 30...Int(bounds.width - 30)),
                                      y: Int.random(in: 60...Int(bounds.height - 60)))
        target = CGPoint(x: location.x - CGFloat(Int.random(in: -50...50)),
                                    y: location.y - CGFloat(Int.random(in: 50...300)))

        fire()
    }
    
    @objc
    public func fire(at location: CGPoint) {

        velocity = CGFloat(Int.random(in: 200...250))
        amount = Double(Int.random(in: 300...600))

        self.location = location
        target = CGPoint(x: location.x - CGFloat(Int.random(in: -50...50)),
                                    y: location.y - CGFloat(Int.random(in: 50...300)))

        fire()
    }
    
    @objc
    public func fire(from point: CGPoint, times: Int, intervall: TimeInterval) {
        var loop: ((Int) -> Void)!
        loop = { [weak self] count in
            guard count > 0 else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + intervall) {
                self?.fire(at: point)
                loop(count - 1)
            }
        }
        loop(times)
    }
    
    @objc
    public func vibrate(times: Int, intervall: TimeInterval) {
        var loop: ((Int) -> Void)!
        loop = { count in
            guard count > 0 else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + intervall) {
                UISelectionFeedbackGenerator().selectionChanged()
                loop(count - 1)
            }
        }
        loop(times)
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
