//
//  ViewController.swift
//  BullsEye
//
//  Created by Sergei Sai on 22.01.2022.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var targetLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var roundLabel: UILabel!
    
    private var currentValue: Int = 0
    private var targetValue = 0
    private var score = 0
    private var round = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.startNewGame()
        
        
        let thumbImageNormal = UIImage(named: "SliderThumb-Normal")!
        self.slider.setThumbImage(thumbImageNormal, for: .normal)
        
        let thumbImageHighlighted = UIImage(named: "SliderThumb-Highlighted")!
        self.slider.setThumbImage(thumbImageHighlighted, for: .highlighted)
        
        let insets = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
        
        let trackLeftImage = UIImage(named: "SliderTrackLeft")!
        let trackLeftResizable = trackLeftImage.resizableImage(withCapInsets: insets)
        self.slider.setMinimumTrackImage(trackLeftResizable, for: .normal)
        
        let trackRightImage = UIImage(named: "SliderTrackRight")!
        let trackRightResizable = trackRightImage.resizableImage(withCapInsets: insets)
        self.slider.setMaximumTrackImage(trackRightResizable, for: .normal)
    }
    
    @IBAction func showAlert() {
        let difference = abs(self.targetValue - self.currentValue)
        var points = 100 - difference
        
        var title: String
        if difference == 0 {
            title = "Perfect!"
            points += 100
        } else if difference < 5 {
            title = "You almost had it!"
            if difference == 1 {
                points += 50
            }
        } else if difference < 10 {
            title = "Pretty good!"
        } else {
            title = "Not even close..."
        }
        
        self.score += points
        
        let message = "You scored \(points) points"
        
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "OK",
                                   style: .default,
                                   handler: { _ in
            self.startNewRound()
        })
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
        //self.startNewRound()
    }
    
    @IBAction func sliderMoved(_ slider: UISlider) {
        self.currentValue = lroundf(slider.value)
        
        print("The value of the slider now: \(slider.value)")
    }
    
    @IBAction func startNewGame() {
        self.score = 0
        self.round = 0
        self.startNewRound()
        
        let transition = CATransition()
        transition.type = .fade
        transition.duration = 1
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        self.view.layer.add(transition, forKey: nil)
    }
    
    func startNewRound() {
        self.targetValue = Int.random(in: 1...100)
        self.currentValue = 50
        self.slider.value = Float(self.currentValue)
        self.round += 1
        
        self.updateLabels()
    }


    func updateLabels() {
        self.targetLabel.text = String(self.targetValue)
        self.scoreLabel.text = String(self.score)
        self.roundLabel.text = String(self.round)
    }
}

