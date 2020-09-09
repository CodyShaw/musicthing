//
//  FretboardView.swift
//  musicthing
//
//  Created by Cody Shaw on 9/8/20.
//  Copyright © 2020 spin. All rights reserved.
//

import Cocoa



@IBDesignable class FretboardController: NSViewController {

    
    @IBOutlet weak var FretboardView: NSView!
    
    override func viewDidLoad() {
    super.viewDidLoad()
        
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
}


@IBDesignable class FretboardView: NSView {
    
    var borderLineWidth: CGFloat {
        return min(bounds.width, bounds.height) * 0.05
    }

    var insetRect: CGRect {
        return bounds.insetBy(
            dx: borderLineWidth * 1,
            dy: borderLineWidth * 3)
    }
    
    override func draw(_ dirtyRect: NSRect) {
        
        super.draw(dirtyRect)

        NSColor.white.setFill()
        __NSRectFill(dirtyRect)
        
        let path = NSBezierPath(rect: insetRect)
        
        let mapleColour = NSColor.init(red: (52)/255, green: (38)/255, blue: (33)/255, alpha: 0.9)
        
        mapleColour.setFill()
        path.fill()
        
        
    }
    
}

extension FretboardView {
  func drawRoundedRect(rect: CGRect, inContext context: CGContext?,
                       radius: CGFloat, borderColor: CGColor, fillColor: CGColor) {
    // 1
    let path = CGMutablePath()
    
    // 2
    path.move( to: CGPoint(x:  rect.midX, y:rect.minY ))
    path.addArc( tangent1End: CGPoint(x: rect.maxX, y: rect.minY ),
                 tangent2End: CGPoint(x: rect.maxX, y: rect.maxY), radius: radius)
    path.addArc( tangent1End: CGPoint(x: rect.maxX, y: rect.maxY ),
                 tangent2End: CGPoint(x: rect.minX, y: rect.maxY), radius: radius)
    path.addArc( tangent1End: CGPoint(x: rect.minX, y: rect.maxY ),
                 tangent2End: CGPoint(x: rect.minX, y: rect.minY), radius: radius)
    path.addArc( tangent1End: CGPoint(x: rect.minX, y: rect.minY ),
                 tangent2End: CGPoint(x: rect.maxX, y: rect.minY), radius: radius)
    path.closeSubpath()
    
    // 3
    context?.setLineWidth(1.0)
    context?.setFillColor(fillColor)
    context?.setStrokeColor(borderColor)
    
    // 4
    context?.addPath(path)
    context?.drawPath(using: .fillStroke)
  }
}
