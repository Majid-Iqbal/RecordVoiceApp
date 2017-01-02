//
//  PlaySoundsViewController.swift
//  RecordVoice
//
//  Created by Majid iqbal on 27/07/2016.
//  Copyright © 2016 AppDeveloper. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    
    var audioPlayer :AVAudioPlayer!
    var recordedAudioUrl :URL!
    
    var audioEngine :AVAudioEngine!
    var audioFile :AVAudioFile!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if let filePath = NSBundle.mainBundle().pathForResource("dad_bond", ofType:".mp3"){
//
//            do{
//                
//            audioPlayer = try AVAudioPlayer(contentsOfURL:NSURL(fileURLWithPath: filePath))
//                
//                audioPlayer.enableRate = true
//            }
//            catch{
//                
//                print("file not found!!")
//            }
//    }
        
        try! audioPlayer = AVAudioPlayer(contentsOf: recordedAudioUrl)
             audioPlayer.enableRate = true

        audioEngine = AVAudioEngine()
        
        
        do {
            
            try audioFile = AVAudioFile(forReading: recordedAudioUrl)
        }
        catch{
            print("audioFile not converted")
        }
        
        }

 
    
    @IBAction func playSlowAudio(_ sender: AnyObject) {
        
        audioEngine.stop()
        audioPlayer.play()
        audioPlayer.rate = 0.5
        audioPlayer.currentTime = 0.0
        
    }

    @IBAction func playFastAudio(_ sender: AnyObject) {
        
        audioEngine.stop()
        audioPlayer.play()
        audioPlayer.rate = 1.5
        audioPlayer.currentTime = 0.0
        
        
    }
    
    @IBAction func playChipMunkAudio(_ sender: Any) {
        
        playAudioWithVariablePitch(pitch: 1000)
    }
    
    
    func playAudioWithVariablePitch(pitch:Float){
        
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attach(audioPlayerNode)
        
        let changePitchEffect = AVAudioUnitTimePitch()
            changePitchEffect.pitch = pitch
        audioEngine.attach(changePitchEffect)
        
        
        audioEngine.connect(audioPlayerNode, to:changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, at: nil, completionHandler: nil)
        do {
            try audioEngine.start()
        }
        catch {
            print("audio Engine not Started")
        }
        
        audioPlayerNode.play()
        
        
        
        
    }
    
    @IBAction func stopAudio(_ sender: AnyObject) {
        audioPlayer.stop()
        audioEngine.stop()
    }
}
