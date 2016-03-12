//
//  ViewController.swift
//  UCI9DC L86 Back to Bach
//
//  Created by Stanislav Sidelnikov on 3/12/16.
//  Copyright © 2016 Stanislav Sidelnikov. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    @IBOutlet weak var playbackSlider: UISlider!
    @IBOutlet weak var volumeSlider: UISlider!
    private var player: AVAudioPlayer?
    private var timer: NSTimer?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupPlayer()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupPlayer() {
        if let filePath = NSBundle.mainBundle().pathForResource("secret_garden", ofType: "mp3") {
            do {
                player = try AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: filePath))
            } catch let error {
                NSLog("Unable to initialize player. Error: \(error)")
                return
            }
            player?.volume = volumeSlider.value
        } else {
            NSLog("Unable to initialize file path")
        }
    }


    @IBAction func playPressed(sender: UIButton) {
        timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "updatePlaybackSlider", userInfo: nil, repeats: true)
        player?.play()
    }
    
    @IBAction func pausePressed(sender: UIButton) {
        timer?.invalidate()
        player?.pause()
    }
    
    @IBAction func stopPressed(sender: UIButton) {
        timer?.invalidate()
        player?.stop()
        player?.currentTime = 0
        playbackSlider.value = 0
    }
    
    @IBAction func changeVolume(sender: UISlider) {
        player?.volume = sender.value
    }
    
    func updatePlaybackSlider() {
        if let player = player where player.duration > 0 {
            playbackSlider.value = Float(player.currentTime) / Float(player.duration)
        } else {
            playbackSlider.value = 0
        }
    }
    
    @IBAction func playbackMove(sender: UISlider) {
        player?.currentTime = Double(Float(player?.duration ?? 0) * playbackSlider.value)
    }
}

