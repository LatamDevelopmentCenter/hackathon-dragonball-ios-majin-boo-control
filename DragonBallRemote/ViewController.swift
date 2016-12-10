//
//  ViewController.swift
//  DragonBallRemote
//
//  Created by Bruno Gonçalves on 09/12/16.
//  Copyright © 2016 panta. All rights reserved.
//

import UIKit
import Alamofire
import CircleSlider

class ViewController: UIViewController {

    @IBOutlet weak var sliderArea: UIView!
    @IBOutlet weak var drive: UISwitch!
    @IBOutlet weak var angleSlider: UISlider!
    @IBOutlet weak var key: UITextField!
    
    
    private var circleSlider: CircleSlider! {
        didSet {
            self.circleSlider.tag = 0
        }
    }
    private var circleProgress: CircleSlider! {
        didSet {
            self.circleProgress.tag = 1
        }
    }
    private var valueLabel: UILabel!
    private var progressLabel: UILabel!
    private var timer: Timer?
    private var progressValue: Float = 0
    
    private var sliderOptions: [CircleSliderOption] {
        return [
            CircleSliderOption.barColor(UIColor.white),
            CircleSliderOption.thumbColor(UIColor.orange),
            CircleSliderOption.trackingColor(UIColor.white),
            CircleSliderOption.barWidth(15),
            CircleSliderOption.thumbWidth(50),
            CircleSliderOption.startAngle(0),
            CircleSliderOption.maxValue(360),
            CircleSliderOption.minValue(1),
            CircleSliderOption.thumbImage(UIImage(named: "sphere")!)
        ]
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
         self.buildCircleSlider()
    }
    
    private func buildCircleSlider() {
        self.circleSlider = CircleSlider(frame: self.sliderArea.bounds, options: self.sliderOptions)
        self.circleSlider?.addTarget(self, action: #selector(valueChange(sender:)), for: .valueChanged)
        self.sliderArea.addSubview(self.circleSlider!)
        self.valueLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        self.valueLabel.textAlignment = .center
        self.circleSlider.addSubview(self.valueLabel)
    }
    
   

    
    func valueChange(sender: CircleSlider) {
        switch sender.tag {
        case 0:
            print(sender.value)
        case 1:
            print(sender.value)
        default:
            break
        }
        move()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.circleSlider.frame = self.sliderArea.bounds
        //self.circleProgress.frame = self.progressArea.bounds
        self.valueLabel.center = CGPoint(x: self.circleSlider.bounds.width * 0.5, y: self.circleSlider.bounds.height * 0.5)
        //self.progressLabel.center = CGPoint(x: self.circleProgress.bounds.width * 0.5, y: self.circleProgress.bounds.height * 0.5)
    }

    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    @IBAction func slider(_ sender: Any) {
        move()
    }
    @IBAction func driveSwitch(_ sender: Any) {
        move()
    }
    @IBOutlet weak var goButton: UIButton!
    @IBAction func goButton(_ sender: Any) {
        move()
    }
    
    func move() {
        let angle = Int(circleSlider.value)
        var go = false
        if drive.isOn {
            go = true
        }
        else {
            go = false
        }
        let params = ["move": go,"heading": angle] as [String : Any]
        let header: HTTPHeaders = ["Content-Type": "application/json"]
        Alamofire.request("http://hackdbz.win/api/" + key.text! + "/control", method: .post, parameters: params, encoding:JSONEncoding.default, headers: header).responseString { response in
            debugPrint(response)
        }
    }

}

