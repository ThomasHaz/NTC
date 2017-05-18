//
//  ViewController.swift
//  NTCColorPicker
//
//  Created by Thomas Hazlett on 18/05/2017.
//  Copyright © 2017 Thomas Hazlett. All rights reserved.
//

import UIKit

extension UIImage {
    func getPixelColor(pos: CGPoint) -> UIColor {
        
        let pixelData = self.cgImage!.dataProvider!.data
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        
        let pixelInfo: Int = ((Int(self.size.width) * Int(pos.y)*3) + Int(pos.x)*3) * 4
        
        let r = CGFloat(data[pixelInfo]) / CGFloat(255.0)
        let g = CGFloat(data[pixelInfo+1]) / CGFloat(255.0)
        let b = CGFloat(data[pixelInfo+2]) / CGFloat(255.0)
        let a = CGFloat(data[pixelInfo+3]) / CGFloat(255.0)
        
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
}

class ViewController: UIViewController {

    
    // MARK: - Outlets
    @IBOutlet weak var colorPickerSuperview: UIView!
    @IBOutlet weak var colorPickerView: UIView!
    @IBOutlet weak var colorLabel: UILabel!
    
    @IBOutlet weak var swatchView: UIView!
    
    @IBOutlet weak var rgbView: UIView!
    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var blueSlider: UISlider!
    
    
    @IBOutlet weak var colorWheel: UIImageView!
    @IBOutlet weak var crosshairView: UIImageView!
    
    var colorButtonImage : ColorButton = ColorButton()
    @IBOutlet weak var colorButton: UIButton!
    
    // MARK: - Runtime
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.rgbView.layer.cornerRadius = 84
        self.rgbView.isHidden = true
        
        self.swatchView.layer.cornerRadius = 8
        self.updateSwatchColor()
        
        self.colorPickerSuperview.isHidden = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Event Handlers
    
    @IBAction func colorButtonPressed(_ sender: Any) {
        
        self.colorPickerSuperview.isHidden = !self.colorPickerSuperview.isHidden
        
    }
    
    
    @IBAction func sliderValueChanged(_ sender: Any) {
        
        self.updateSwatchColor()
        
    }
    
    
    
    @IBAction func toggleMoreButtonPressed(_ sender: UIButton) {
        // Toggle between RGB Sliders and Color Chart
        self.rgbView.isHidden = !self.rgbView.isHidden
        self.crosshairView.isHidden = !self.crosshairView.isHidden
        
    }

    
    
    
    
    
    
    // MARK: Touch Handling
    
    var offset : CGPoint = CGPoint(x: 0, y: 0)
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(self.rgbView.isHidden) {
            var loc = touches.first!.location(in: self.colorWheel)
            
            offset.y = loc.y - self.crosshairView.center.y
            offset.x = loc.x - self.crosshairView.center.x
            
            loc.y -= offset.y
            loc.x -= offset.x
            
            updateCrosshairPosition(center: loc)
            updateSwatchColor()
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(self.rgbView.isHidden) {
            var loc = touches.first!.location(in: self.colorWheel)
            
            if (self.pointWithinCircleOfRadius(84, point: loc, centeredAt: self.colorWheel.center)) {
                loc.y -= offset.y
                loc.x -= offset.x
                
                updateCrosshairPosition(center: loc)
                updateSwatchColor()
            }
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.colorLabel.text = NTC.nameOf(self.swatchView.backgroundColor!)
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.colorLabel.text = NTC.nameOf(self.swatchView.backgroundColor!)
    }
    
    
    
    
    
    // MARK: UI
    
    func updateCrosshairPosition(center: CGPoint) {
        if (self.pointWithinCircleOfRadius(84, point: center)) {
            self.crosshairView.center = center
        }
    }
    
    func updateSwatchColor() {
        if(self.rgbView.isHidden) {
            if(self.pointWithinCircleOfRadius(3, point: self.crosshairView.center, centeredAt: CGPoint(x:84, y:84))) {
                self.swatchView.backgroundColor = UIColor.white
            } else {
                self.swatchView.backgroundColor = #imageLiteral(resourceName: "color-wheel-3").getPixelColor(pos: self.crosshairView.center)
            }
            
            var r : CGFloat = 0.0
            var g : CGFloat = 0.0
            var b : CGFloat = 0.0
            self.swatchView.backgroundColor?.getRed(&r, green: &g, blue: &b, alpha: nil)
            
            self.redSlider.value = Float(r * 255.0)
            self.greenSlider.value = Float(g * 255.0)
            self .blueSlider.value = Float(b * 255.0)
            
        } else {
            self.swatchView.backgroundColor = UIColor(red: CGFloat(self.redSlider.value / 255.0), green: CGFloat(self.greenSlider.value / 255.0), blue: CGFloat(self.blueSlider.value / 255.0), alpha: 1.0)
        }
        self.colorLabel.text = NTC.nameOf(self.swatchView.backgroundColor!)
        
        colorButtonImage.fillColor = self.swatchView.backgroundColor!
        self.colorButton.setImage(colorButtonImage.imageOfColorbutton, for: UIControlState.normal)
        
        
    }


    // MARK: - Utility Helpers
    
    func distanceFromPoint(_ center : CGPoint, touch: CGPoint) -> CGFloat
    {
        let dx : CGFloat = touch.x-center.x
        let dy : CGFloat = touch.y-center.y
        
        return sqrt(dx*dx + dy*dy)
    }
    func pointWithinCircleOfRadius(_ radius: CGFloat, point: CGPoint) -> Bool {
        let dx : CGFloat = point.x - radius
        let dy : CGFloat = point.y - radius
        
        return ((dx * dx + dy * dy) <= radius * radius)
    }
    func pointWithinCircleOfRadius(_ radius: CGFloat, point: CGPoint, centeredAt: CGPoint) -> Bool {
        let dx : CGFloat = point.x - centeredAt.x
        let dy : CGFloat = point.y - centeredAt.y
        
        return ((dx * dx + dy * dy) <= radius * radius)
    }
}

