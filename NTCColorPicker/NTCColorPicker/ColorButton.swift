//
//  StyleKitName.swift
//  ProjectName
//
//  Created by Thomas Hazlett on 18/05/2017.
//  Copyright (c) 2017 CompanyName. All rights reserved.
//
//  Generated by PaintCode (www.paintcodeapp.com)
//



import UIKit

class ColorButton : NSObject {

    //// Cache

    fileprivate struct Cache {
        static var imageOfColorbutton: UIImage?
        static var colorbuttonTargets: [AnyObject]?
    }

    //// Drawing Methods
    private var _fillColor : UIColor = UIColor.black
    var fillColor: UIColor {
        get {
            return _fillColor
        }
        set(newValue) {
            _fillColor = newValue
            Cache.imageOfColorbutton = nil
        }
    }
    
    func drawColorbutton() {
        //// Color Declarations
        let borderColor = UIColor(red: 0.592, green: 0.592, blue: 0.592, alpha: 1.000)

        //// Rectangle Drawing
        let rectanglePath = UIBezierPath(rect: CGRect(x: 1, y: 1, width: 37, height: 37))
        UIColor.white.setFill()
        rectanglePath.fill()
        borderColor.setStroke()
        rectanglePath.lineWidth = 2
        rectanglePath.stroke()


        //// Oval Drawing
        let ovalPath = UIBezierPath(ovalIn: CGRect(x: 6, y: 6, width: 27, height: 27))
        self.fillColor.setFill()
        ovalPath.fill()
        borderColor.setStroke()
        ovalPath.lineWidth = 2.2
        ovalPath.stroke()
    }

    //// Generated Images

    var imageOfColorbutton: UIImage {
        if Cache.imageOfColorbutton != nil {
            return Cache.imageOfColorbutton!
        }

        UIGraphicsBeginImageContextWithOptions(CGSize(width: 39, height: 39), false, 0)
            self.drawColorbutton()

        Cache.imageOfColorbutton = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return Cache.imageOfColorbutton!
    }

    //// Customization Infrastructure

    @IBOutlet var colorbuttonTargets: [AnyObject]! {
        get { return Cache.colorbuttonTargets }
        set {
            Cache.colorbuttonTargets = newValue
            for target: AnyObject in newValue {
                target.perform(NSSelectorFromString("setImage:"), with: self.imageOfColorbutton)
            }
        }
    }

}