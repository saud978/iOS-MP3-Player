//
//  ViewController.swift
//  mp3Player
//
//  Created by Saud Al-Mutlaq on 8/14/2015.
//  Copyright (c) 2015 saudsoft.com. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation
import MediaPlayer

class ViewController: UIViewController, AVAudioPlayerDelegate
{
    static let sharedInstance = ViewController()
    
    @IBOutlet weak var albumArtImage        : UIImageView!
    @IBOutlet weak var durationLabel        : UILabel!
    @IBOutlet weak var totalDurationLabel   : UILabel!
    @IBOutlet weak var sliderTimer          : UISlider!
    @IBOutlet weak var volumeView           : UIView!
    @IBOutlet weak var repeatingNumbers     : UISegmentedControl!
    @IBOutlet weak var pauseBtn             : UIButton!
    @IBOutlet weak var playBtn              : UIButton!
    
    var quraan  : AVAudioPlayer  = AVAudioPlayer()
    var updater : CADisplayLink! = nil
    
    var opaques = [String:Any]()
    var which = 0 // 0 means use target-action, 1 means use handler
    
    
    @IBAction func forward15(_ sender: Any) {
        if quraan.currentTime < (quraan.duration - 15) {
            quraan.currentTime += 15
        }
    }
    
    @IBAction func backward15(_ sender: Any) {
        if quraan.currentTime > 15 {
            quraan.currentTime -= 15
        } else {
            quraan.currentTime = 0
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareRemoteControlAction()
        
        UIApplication.shared.beginReceivingRemoteControlEvents()
        
        sliderTimer.setThumbImage(UIImage(named: "ThumbImage2.png"), for: .normal)
        sliderTimer.setThumbImage(UIImage(named: "ThumbImageSelected.png"), for: .highlighted)
        
        playMP3()
        
        durationLabel.text = "00:00:00"
        sliderTimer.value = 0

    }
    
    func prepareRemoteControlAction() {
        let mp3Player = MPRemoteCommandCenter.shared()
        
        switch which {
        case 0:
            mp3Player.togglePlayPauseCommand.addTarget(self, action: #selector(doPlayPause))
            
            mp3Player.playCommand.addTarget(self, action:#selector(doPlay))
            mp3Player.pauseCommand.addTarget(self, action:#selector(doPause))

        case 1:
            opaques["playPause"] = mp3Player.togglePlayPauseCommand.addTarget {
                [unowned self] _ in
                let player = self.quraan
                if player.isPlaying { player.pause() } else { player.play() }
                return .success
            }
            opaques["play"] = mp3Player.playCommand.addTarget {
                [unowned self] _ in
                let player = self.quraan
                player.play()
                return .success
            }
            opaques["pause"] = mp3Player.pauseCommand.addTarget {
                [unowned self] _ in
                let player = self.quraan
                player.pause()
                return .success
            }
        default:break
        }
    }
    
    @objc func doPlayPause(_ event:MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {
        print("playpause")
        let p = self.quraan
        if p.isPlaying { p.pause() } else { p.play() }
        return .success
    }
    
    @objc func doPlay(_ event:MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {
        print("play")
        let p = self.quraan
        p.play()
        
        return .success
    }
    
    @objc func doPause(_ event:MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {
        print("pause")
        let p = self.quraan
        p.pause()
        
        return .success
    }
    
    //    func doLike(_ event:MPRemoteCommandEvent) {
    //        print("like")
    //    }
    
    // MARK: Audio Delegate Methods
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        playBtn.isHidden = false
        pauseBtn.isHidden = true
    }
    
    @objc func trackAudio() {
        let currentTime = Int(quraan.currentTime)
        let remainingTime = Int(quraan.duration-quraan.currentTime)
        
        let seconds: Int = currentTime % 60
        let minutes: Int = (currentTime / 60) % 60
        let hours: Int = currentTime / 3600
        
        let rseconds: Int = remainingTime % 60
        let rminutes: Int = (remainingTime / 60) % 60
        let rhours: Int = remainingTime / 3600
        
        durationLabel.text = NSString(format: "%02d:%02d:%02d", hours, minutes,seconds) as String
        totalDurationLabel.text = NSString(format: "%02d:%02d:%02d", rhours, rminutes,rseconds) as String
        
        sliderTimer.value = Float(quraan.currentTime)
    }
    
    @IBAction func sliderMoved(_ sender: AnyObject)
    {
        quraan.currentTime = Double(sliderTimer.value)
    }
    
    func playMP3() {
        updater = CADisplayLink(target: self, selector: #selector(ViewController.trackAudio))
        updater.preferredFramesPerSecond = 1
        updater.add(to: RunLoop.current, forMode: RunLoop.Mode.common)
        
        prepareAudio("file001")
        
        quraan.delegate = self
        quraan.prepareToPlay()
        
        sliderTimer.minimumValue = 0
        sliderTimer.maximumValue = Float(quraan.duration)
        
        let playerItem = AVPlayerItem(url: Bundle.main.url(forResource: "file001", withExtension: "mp3")!)
        let metadataList = playerItem.asset.metadata
        
        var trackLabel = ""
        var artistLabel = ""
        var artistImage: UIImage = UIImage()
        
        for item in metadataList {
            
            guard let key = convertFromOptionalAVMetadataKey(item.commonKey), let value = item.value else {
                continue
            }
            
            switch key {
            case "title" : trackLabel = value as! String
            case "artist": artistLabel = value as! String
            case "artwork" where value is Data : artistImage = UIImage(data: value as! Data)!
            default:
                continue
            }
        }
        
        let albumArt = MPMediaItemArtwork(boundsSize: artistImage.size) { (cgSize) -> UIImage in
            return artistImage
        }
        
        let roundedImage = artistImage.rounded(with: .white, width: 3)
        
        albumArtImage.image = roundedImage
        
        let mpic = MPNowPlayingInfoCenter.default()
        mpic.nowPlayingInfo = [
            MPMediaItemPropertyTitle: trackLabel,
            MPMediaItemPropertyArtist: artistLabel,
            MPMediaItemPropertyArtwork: albumArt,
            MPMediaItemPropertyPlaybackDuration: quraan.duration
        ]
        print(quraan.duration)
        
        // https://github.com/mattneub/Programming-iOS-Book-Examples/tree/master/bk2ch14p643ducking/ch27p912ducking
    }
    
    func setNumberOfRepeats() {
        let numberOfRepeat = 0
        //        if (numberOfRepeat==1)
        //        {
        //            numberOfRepeat = -1
        //        }
        quraan.numberOfLoops = numberOfRepeat // play indefinitely
    }
        
    func pausePlayer() {
        quraan.pause()
    }
    
    func prepareAudio(_ fileName: String) {
        do {
            // make audio paly in background
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            print("Playback OK")
            try AVAudioSession.sharedInstance().setActive(true)
            print("Session is Active")
            
        } catch {
            print(error)
        }
        
        UIApplication.shared.beginReceivingRemoteControlEvents()
        
        let url:URL = Bundle.main.url(forResource: fileName, withExtension: "mp3")!
        
        do {
            quraan = try AVAudioPlayer(contentsOf: url, fileTypeHint: nil)
        }
        catch let error as NSError {
            print(error.description)
        }
    }
    
    @IBAction func fastForward(_ sender: AnyObject)
    {
        //quraan.currentTime = 1438
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Controllers Action
    
    @IBAction func stopButton(_ sender: AnyObject) {
        pauseButton(self)
        quraan.stop()
        quraan.currentTime = 0
    }
    
    @IBAction func prevButtonPressed(_ sender: Any) {
        stopButton(self)
        playButton(self)
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        prevButtonPressed(self)
    }
    
    @IBAction func pauseButton(_ sender: AnyObject) {
        playBtn.isHidden = !playBtn.isHidden
        pauseBtn.isHidden = !pauseBtn.isHidden
        pausePlayer()
    }
    
    @IBAction func playButton(_ sender: AnyObject) {
        self.setNumberOfRepeats()
        quraan.play()
        playBtn.isHidden = !playBtn.isHidden
        pauseBtn.isHidden = !pauseBtn.isHidden
    }
    
    
    
    // must deregister or can crash later!
    
    deinit {
        print("deinit")
        let scc = MPRemoteCommandCenter.shared()
        switch which {
        case 0:
            scc.togglePlayPauseCommand.removeTarget(self)
            scc.playCommand.removeTarget(self)
            scc.pauseCommand.removeTarget(self)
            scc.likeCommand.removeTarget(self)
        case 1:
            scc.togglePlayPauseCommand.removeTarget(self.opaques["playPause"])
            scc.playCommand.removeTarget(self.opaques["play"])
            scc.pauseCommand.removeTarget(self.opaques["pause"])
        default:break
        }
    }
    
    @IBAction func dismissViewController(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromOptionalAVMetadataKey(_ input: AVMetadataKey?) -> String? {
    guard let input = input else { return nil }
    return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromAVAudioSessionCategory(_ input: AVAudioSession.Category) -> String {
    return input.rawValue
}
