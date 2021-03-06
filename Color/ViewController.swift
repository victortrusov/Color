//
//  ViewController.swift
//  Color
//
//  Created by Victor Trusov on 17.12.16.
//  Copyright © 2016 Victor Trusov. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    @IBOutlet weak var messagelabel: UILabel!
    @IBOutlet weak var maintextview: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var rgblabel: UILabel!
    @IBOutlet weak var hsblabel: UILabel!
    var touchn = 0;
    var touchtype="";
    var h : CGFloat = 0.0;
    var s : CGFloat = 1.0;
    var b : CGFloat = 1.0;
    var taptime :Int64 = 0;
    var xx = 0;
    var yy = 0;
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        imageView.isUserInteractionEnabled = true;
        label.isUserInteractionEnabled = true;
        let tap = UITapGestureRecognizer(target: self, action: #selector(labelTap))
        label.addGestureRecognizer(tap);
        setColorHSB();
        messagelabel.layer.masksToBounds=true;
        messagelabel.layer.cornerRadius=15;
        messagelabel.layer.borderColor = UIColor.black.cgColor;
        messagelabel.layer.borderWidth = 2.0;
    }
    
    func labelTap() {
        UIPasteboard.general.string = getHEX();
        showMessage();
    }
    
    func showMessage() {
        messagelabel.alpha=0.8;
        UIView.animate(withDuration: 1.5, animations: {
            self.messagelabel.alpha = 0.0
        })
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        taptime=currentTimeMillis();
        let touch = touches.first;
        //istouch=true;
        let point = touch!.location(in: self.view);
        touchn = 0;
        touchtype="";
        xx=Int(point.x);
        yy=Int(point.y);
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
       //touchn=0;
        if ((currentTimeMillis() - taptime) < 150 && touchn<5)
        {
            if (maintextview.isHidden)
            {
                maintextview.isHidden=false;
                rgblabel.isHidden = true;
                hsblabel.isHidden = true;
            }
            else if (rgblabel.isHidden)
            {
                rgblabel.isHidden=false;
                hsblabel.isHidden=false;
            }
            else{
                maintextview.isHidden=true;
                rgblabel.isHidden = true;
                hsblabel.isHidden = true;
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first;
        //istouch=true;
        let point = touch!.location(in: self.view);
        if !(Int(point.x)==xx && Int(point.y)==yy)
        {
            positionChange(x: point.x, y: point.y);
        }
        
    }
    
    func positionChange(x:CGFloat, y:CGFloat)
    {
        let curx = Int(x);
        let cury = Int(y);
        //labelx.text=String(curx);
        //labely.text=String(cury);
        
        if (touchn<5) {
            touchn+=1;
        }
        else
        {
            if(touchtype=="")
            {
                getTouchType(curx: curx, cury: cury);
            }
            else {
            if (touchtype=="d")
            {
                h+=CGFloat(Double((curx-xx))/1536.0);
                if (h>=1) { h-=1; }
                if (h<0) { h+=1; }
                setColorHSB();
                
            }
            else if (touchtype=="h")
            {
                b+=CGFloat(Double((-curx+xx))/300.0);
                if (b>1) { b=1; }
                if (b<0) { b=0; }
                setColorHSB();
                
            }
            else if (touchtype=="v")
            {
                s+=CGFloat(Double((cury-yy))/300.0);
                if (s>1) { s=1; }
                if (s<0) { s=0; }
                setColorHSB();
                
            }
            
            xx=curx;
            yy=cury;
            }
        }
        
    }
    
    func getTouchType(curx:Int,cury:Int)
    {
        let x = abs(curx-xx);
        let y = abs(cury-yy);
        //labelx.text=String(x);
        //labely.text=String(y);

        
        if (x>y*2)
        {
            touchtype="h"
        }
        else if (y>x*4)
        {
            touchtype="v"
        }
        else{
            touchtype="d"
        }

    }
    
    
    func setColorHSB()
    {
        
        self.view.backgroundColor = UIColor(
            hue: h,
            saturation: s,
            brightness: b,
            alpha: 1.0);
        label.text=getHEX();
        rgblabel.text=self.view.backgroundColor?.toRbg();
        hsblabel.text=String(lroundf(Float(h)*360))+" :H\n"+String(lroundf(Float(s)*100))+" :S\n"+String(lroundf(Float(b)*100))+" :B"
        setColorToControls(b: b);
    }
    
    func setColorToControls(b: CGFloat)
    {
        var c : UIColor = UIColor(
            hue: 0.0,
            saturation: 0.0,
            brightness: 0.0,
            alpha: 1.0);
        if (b<0.35)
        {
    
            c=UIColor(
                hue: 0.0,
                saturation: 0.0,
                brightness: 0.5,
                alpha: 1.0);
        }
        label.textColor=c;
        messagelabel.textColor=c;
        messagelabel.layer.borderColor=c.cgColor;
        rgblabel.textColor = c;
        hsblabel.textColor = c;

    }
    
    func getHEX() -> String
    {
        let h = self.view.backgroundColor?.toHex();
        return "#"+h!;
    }
    
    func currentTimeMillis() -> Int64{
        let nowDouble = NSDate().timeIntervalSince1970
        return Int64(nowDouble*1000)
    }

}

extension UIColor {
    
    // MARK: - Initialization
    
    convenience init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt32 = 0
        
        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 1.0
        
        let length = hexSanitized.characters.count
        
        guard Scanner(string: hexSanitized).scanHexInt32(&rgb) else { return nil }
        
        if length == 6 {
            r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            b = CGFloat(rgb & 0x0000FF) / 255.0
            
        } else if length == 8 {
            r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            a = CGFloat(rgb & 0x000000FF) / 255.0
            
        } else {
            return nil
        }
        
        self.init(red: r, green: g, blue: b, alpha: a)
    }
    
    // MARK: - Computed Properties
    
    var toHex: String? {
        return toHex()
    }
    
    // MARK: - From UIColor to String
    
    func toHex(alpha: Bool = false) -> String? {
        guard let components = cgColor.components, components.count >= 3 else {
            return nil
        }
        
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        var a = Float(1.0)
        
        if components.count >= 4 {
            a = Float(components[3])
        }
        
        if alpha {
            return String(format: "%02lX%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255), lroundf(a * 255))
        } else {
            return String(format: "%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
        }
    }
    
    func toRbg(alpha: Bool = false) -> String? {
        guard let components = cgColor.components, components.count >= 3 else {
            return nil
        }
        
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])

        return  "R: " + String(lroundf(r * 255)) + "\nG: " + String(lroundf(g * 255)) + "\nB: " + String(lroundf(b * 255))
        
    }
    
}

