//
//  TraingleSaver.swift
//  TriangleSaver
//
//  Created by Jens on 10.05.18.
//  Copyright © 2018 JNSDBR. All rights reserved.
//

import Cocoa
import ScreenSaver

class TraingleSaver: ScreenSaverView {
    let elementSize :CGFloat = 40
    var elements = [Element]()
    var animationTimer = millis() + 5000
    
    override init?(frame: NSRect, isPreview: Bool) {
        super.init(frame: frame, isPreview: isPreview)

        for row in stride(from: 0, to: self.bounds.size.height, by: elementSize) {
            for col in stride(from: 0, to: self.bounds.size.width, by: elementSize) {
                let e :Element = Element(x: CGFloat(col), y: self.bounds.size.height - elementSize - row, size: elementSize)
                elements.append(e)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func startAnimation() {
        super.startAnimation()
    }
    
    override func stopAnimation() {
        super.stopAnimation()
    }
    
    override func draw(_ rect: NSRect) {
        super.draw(rect)
    }
    
    override func animateOneFrame() {
        NSColor.white.setFill()
        NSRectFill(self.bounds)
        
        /*let time: Int = Date().millisecondsSince1970
        let hello :String = String(time)
        hello.draw(at: NSPoint(x: 100.0, y: 200.0), withAttributes:nil)
         */
        
        if (animationTimer < millis())
        {
            animationTimer = millis() + 5000;
            
            for element in elements {
                element.toggleAnimation()
            }
        }
        
        // Draw elements
        for element in elements {
            element.draw()
        }
    }
    
    override func hasConfigureSheet() -> Bool {
        return false
    }
    
    override func configureSheet() -> NSWindow? {
        return nil
    }
}


class Element {
    let position :NSPoint
    let size :CGFloat
    var rotation :Int
    var animationTimeout :Int
    var isAnimating :Bool = true
    
    init(x :CGFloat, y :CGFloat, size: CGFloat) {
        position = NSPoint(x: x, y: y)
        self.size = size
        
        let randomValue = arc4random_uniform(41) + 0;
        
        if (randomValue < 10)
        {
            rotation = 1;
        }
        else if (randomValue > 10 && randomValue < 20)
        {
            rotation = 2;
        }
        else if (randomValue > 20 && randomValue < 30)
        {
            rotation = 3;
        }
        else
        {
            rotation = 4;
        }
        
        animationTimeout = millis() + Int(arc4random_uniform(1001) + 500)
    }
    
    func toggleAnimation() {
        isAnimating = !isAnimating
        animationTimeout = millis() + Int(arc4random_uniform(1001) + 500)
    }
    
    func draw() {
        
        if (isAnimating && animationTimeout < millis()) {
            animationTimeout = millis() + Int(arc4random_uniform(1001) + 500)
            rotation = rotation + 1
            
            if (rotation >= 4) {
                rotation = 0;
            }
        }
        
        var x1 :CGFloat
        var y1 :CGFloat
        var x2 :CGFloat
        var y2 :CGFloat
        var x3 :CGFloat
        var y3 :CGFloat
        
        switch rotation {
        case 1:
            x1 = position.x
            y1 = position.y + size
            x2 = position.x
            y2 = position.y
            x3 = position.x + size
            y3 = position.y + size
        case 2:
            x1 = position.x;
            y1 = position.y + size;
            x2 = position.x;
            y2 = position.y;
            x3 = position.x + size;
            y3 = position.y;
        case 3:
            x1 = position.x;
            y1 = position.y;
            x2 = position.x + size;
            y2 = position.y;
            x3 = position.x + size;
            y3 = position.y + size;
        default:
            x1 = position.x + size;
            y1 = position.y;
            x2 = position.x + size;
            y2 = position.y + size;
            x3 = position.x;
            y3 = position.y + size;
        }
        
        let color = NSColor.black
        color.setFill()
        let path :NSBezierPath = NSBezierPath()
        path.move(to: NSPoint(x: x1, y: y1))
        path.line(to: NSPoint(x: x2, y: y2))
        path.line(to: NSPoint(x: x3, y: y3))
        path.fill()
    }
}

func millis() -> Int {
    return Date().millisecondsSince1970
}

extension Date {
    var millisecondsSince1970:Int {
        return Int((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    init(milliseconds:Int) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds / 1000))
    }
}

