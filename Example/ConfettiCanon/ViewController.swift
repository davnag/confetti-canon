//
//  ViewController.swift
//  ConfettiCanon
//
//  Created by David on 01/27/2020.
//  Copyright (c) 2020 David. All rights reserved.
//

import UIKit
import ConfettiCanon

class ViewController: UIViewController {
    
    lazy var partyCanon: PartyCanon = PartyCanon(frame: view.bounds)
    
    var confettiRain: Bool = false {
        didSet {
            if confettiRain {
                self.startConfettiRain()
            } else {
                self.stopConfettiRain()
            }
        }
    }
    
    @IBAction func tapGestureButtonAction(_ sender: Any) {

    }
    
    @IBAction func randomCanonButtonAction(_ sender: Any) {
        partyCanon.randomParty()
    }
    
    @IBAction func confettiRainButtonAction(_ sender: Any) {
        confettiRain = !confettiRain
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(partyCanon)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(fireCanon))
        view.addGestureRecognizer(tapGesture)

        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(fireCanons))
        view.addGestureRecognizer(panGesture)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        var loop: ((Int) -> Void)!
        loop = { [weak self] count in
          guard count > 0 else { return }
          //Do your stuff
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
                self?.partyCanon.fireRandomCanon(at: self!.view.center)
            loop(count - 1)
          }
        }
        loop(10)
    }
   
    @objc
    func fireCanon(gesture: UITapGestureRecognizer) {

        let location = gesture.location(in: view)
        
        if view.hitTest(location, with: nil) is UIButton {
            return
        }
        
        partyCanon.fireRandomCanon(at: location)
    }

    @objc
    func fireCanons(gesture: UIPanGestureRecognizer) {

        if gesture.state != .ended {
            let location = gesture.location(in: view)
            partyCanon.fireRandomCanon(at: location)
        }
    }
    
}

