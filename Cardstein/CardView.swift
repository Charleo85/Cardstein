//
//  var cardViews						: [CardView]? CardView.swift
//  Cardstein
//
//  Created by CharlieWu on 3/7/16.
//  Copyright © 2016 CharlieWu. All rights reserved.
//

import UIKit
import QuartzCore

class CardView: UIView {
    
    @IBOutlet var cardImage		: UIImageView!
    var card					: Card?
	var enabled					: Bool = false
	var revealed				: Bool = true
    
    required init?(coder aDecoder: NSCoder) {
        var tapRecognizer	: UITapGestureRecognizer
        
        super.init(coder: aDecoder)
        
        tapRecognizer = UITapGestureRecognizer(target: self, action: "handleTap:")
        self.addGestureRecognizer(tapRecognizer)
    }
    
    func imageNameFor(card: Card) -> String {
        var imageName = "card_"
        
        imageName += card.rank.identifier + card.suit.identifier
        
        return imageName
    }
    
    func handleTap(recognizer: UIGestureRecognizer) {
        enabled = !enabled
        if enabled {
            self.alpha = 1
        }else {
            self.alpha = 0.5
        }
    }
    
    func update() {
        if self.enabled {
            self.alpha = 1
            if self.revealed {
                if self.card != nil {
                    self.cardImage.image = UIImage(named: self.imageNameFor(card!))
                }else {
                    self.cardImage.image = UIImage(named: "back")
                }
            }else {
                self.cardImage.image = UIImage(named: "back2")
            }
        }else{
            self.alpha = 0.5
        }
    }
    
    func hide() {
        revealed = !revealed
        if self.revealed {
            if self.card != nil {
                self.cardImage.image = UIImage(named: self.imageNameFor(card!))
            }else{
                self.cardImage.image = UIImage(named: "back")
            }
        }else {
            self.cardImage.image = UIImage(named: "back2")
        }
        self.beginReveal(self.revealed)
    }
    
    func beginReveal(clockwise: Bool = true) {
        let flipAnimation	= CABasicAnimation(keyPath: "transform")
        var endTransform	= CATransform3DIdentity
        let endAngle		= CGFloat(M_PI_2) * (clockwise ? 1.0 : -1.0)
        
        endTransform.m34 = -1.0 / 500.0
        endTransform = CATransform3DRotate(endTransform, endAngle, 0, 1, 0)
        flipAnimation.fromValue = NSValue(CATransform3D: CATransform3DIdentity)
        flipAnimation.toValue = NSValue(CATransform3D: endTransform)
        flipAnimation.duration = Consts.Views.RevealAnimationTime / 2.0
        flipAnimation.setValue(NSNumber(bool: clockwise), forKey: "clockwise")
        flipAnimation.delegate = self
        self.cardImage.layer.transform = endTransform
        self.cardImage.layer.addAnimation(flipAnimation, forKey: "begin_reveal")
    }
    
    func finishReveal(clockwise: Bool = true) {
        let flipAnimation	= CABasicAnimation(keyPath: "transform")
        var startTransform	= CATransform3DIdentity
        let endTransform	= CATransform3DIdentity
        let startAngle		= CGFloat(M_PI_2) * (clockwise ? -1.0 : 1.0)
        
//        self.update()
        startTransform.m34 = -1.0 / 500.0
        startTransform = CATransform3DRotate(startTransform, startAngle, 0, 1, 0)
        flipAnimation.fromValue = NSValue(CATransform3D: startTransform)
        flipAnimation.toValue = NSValue(CATransform3D: endTransform)
        flipAnimation.duration = Consts.Views.RevealAnimationTime / 2.0
        self.cardImage.layer.transform = endTransform
        self.cardImage.layer.addAnimation(flipAnimation, forKey: "end_reveal")
    }
    
    override func animationDidStop(animation: CAAnimation, finished flag: Bool) {
        if let clockwise = animation.valueForKey("clockwise") as? NSNumber {
            self.finishReveal(clockwise.boolValue)
        }
    }

    

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
