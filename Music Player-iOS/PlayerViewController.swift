//
//  PlayerViewController.swift
//  Music Player-iOS
//
//  Created by Teodor Stanishev on 23.07.19.
//  Copyright © 2019 Teodor Stanishev. All rights reserved.
//

import UIKit
import MediaPlayer
import AVFoundation

class PlayerViewController: UIViewController {
    static var musicPlayer = AVAudioPlayer()
    @IBOutlet weak var albumCoverOutlet: UIImageView!
    
    @IBOutlet weak var songNameOutlet: UILabel!
    var isChangingSlider = false
    static var isPlayerInitialised = false
    static var coverImage:UIImage!
    static var songName:String!
    @IBOutlet weak var artworkView: UIImageView!
    
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var timeSliderOutlet: UISlider!
    
    
    @IBAction func timerSliderEnd(_ sender: UISlider) {
        if(PlayerViewController.isPlayerInitialised){
            isChangingSlider = true
            PlayerViewController.musicPlayer.currentTime = TimeInterval(sender.value)
            currentTimeLabel.text = PlayerViewController.secondsToHoursMinutesSeconds(seconds: Int(sender.value))
            isChangingSlider = false
        }
    }
    @IBAction func nextButton(_ sender: UIButton) {
        sender.backgroundColor = UIColor(red: 0.0, green: 0.72, blue: 0.98, alpha: 0.5)
        sender.layer.cornerRadius = sender.frame.width / 2
        nextSong()
    }
    @IBAction func nextButtonRelease(_ sender: UIButton) {
        sender.backgroundColor = UIColor(red: 0.0, green: 0.72, blue: 0.98, alpha: 0)
    }
    
    @IBAction func previousButton(_ sender: UIButton) {
        sender.backgroundColor = UIColor(red: 0.0, green: 0.72, blue: 0.98, alpha: 0.5)
        sender.layer.cornerRadius = sender.frame.width / 2
        previousSong()
    }
    
    @IBAction func previousButtonRelease(_ sender: UIButton) {
        sender.backgroundColor = UIColor(red: 0.0, green: 0.72, blue: 0.98, alpha: 0)
    }
    
    @IBAction func playButton(_ sender: UIButton) {
        sender.backgroundColor = UIColor(red: 0.0, green: 0.72, blue: 0.98, alpha: 0.5)
        sender.layer.cornerRadius = sender.frame.width / 2
        if(PlayerViewController.isPlayerInitialised){
            //Toggle Play/Pause
            if(PlayerViewController.musicPlayer.isPlaying){
                PlayerViewController.musicPlayer.pause()
            }else{
                PlayerViewController.musicPlayer.play()
            }
            
        }
        
    }
    @IBAction func playButtonRelease(_ sender: UIButton) {
        sender.backgroundColor = UIColor(red: 0.0, green: 0.72, blue: 0.98, alpha: 0)
    }
    
    @objc func onEverySecond(){
        if(PlayerViewController.musicPlayer.isPlaying && !isChangingSlider && viewIfLoaded != nil){
            timeSliderOutlet.maximumValue = Float(PlayerViewController.musicPlayer.duration)
            timeSliderOutlet.value = Float(PlayerViewController.musicPlayer.currentTime)
            currentTimeLabel.text = PlayerViewController.secondsToHoursMinutesSeconds(seconds: Int(PlayerViewController.musicPlayer.currentTime))
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSlider()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        //Create an interval to update the showed time on the UI
        if(PlayerViewController.isPlayerInitialised){
            if(PlayerViewController.musicPlayer.isPlaying){
                onEverySecond()
                updateCoverImage()
                updateSongName()
            }
            Timer.scheduledTimer(timeInterval: 0.1 , target: self , selector: #selector(self.onEverySecond) , userInfo: nil , repeats: true)
        }
        //

        
    }
    
    public static func playSong(song: Music){
        do{
            print("URL IS: " + song.songURL.absoluteString)
            musicPlayer = try AVAudioPlayer(contentsOf: song.songURL)
            isPlayerInitialised = true
            let audioSession = AVAudioSession.sharedInstance()
            do{
                try audioSession.setCategory(.playback)
                musicPlayer.play()
                coverImage = UIImage(contentsOfFile: song.coverArtURL.path)
                setupNowPlaying(title: song.name )
                
                songName = song.name
            }catch let sessionError{
                print(sessionError)
            }
        }catch let playerError{
            print(playerError)
        }
    }
    
    public static func setupNowPlaying(title:String) {
        UIApplication.shared.beginReceivingRemoteControlEvents()
        let commandCenter = MPRemoteCommandCenter.shared()
        
        commandCenter.pauseCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in
            //Update your button here for the pause command
            self.musicPlayer.pause()
            return .success
        }
        
        commandCenter.playCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in
            //Update your button here for the play command
            self.musicPlayer.play()
            return .success
        }
        
        
        
        // Define Now Playing Info
        var nowPlayingInfo = [String : Any]()
        if let image = coverImage {
            nowPlayingInfo[MPMediaItemPropertyArtwork] =
                MPMediaItemArtwork(boundsSize: image.size) { size in
                    return image
            }
        }
        
        nowPlayingInfo[MPMediaItemPropertyTitle] = title
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = musicPlayer.currentTime
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = musicPlayer.duration
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = musicPlayer.rate
        
        
        
        // Set the metadata
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    
    
    func updateCoverImage(){
            albumCoverOutlet.image = PlayerViewController.coverImage
    }
    func updateSongName(){
        songNameOutlet.text = PlayerViewController.songName
    }
    
    private func setupSlider(){
        let sliderImage = UIImage(named: "circle-slider")
        
        timeSliderOutlet.setThumbImage( sliderImage?.resizeImage(targetSize: CGSize(width: 20,height: 20)) , for: .normal)
        timeSliderOutlet.setThumbImage( sliderImage?.resizeImage(targetSize: CGSize(width: 25,height: 25)) , for: .selected)
    }
    
    
    func pauseSong(){
        if PlayerViewController.isPlayerInitialised{
            if PlayerViewController.musicPlayer.isPlaying{
                PlayerViewController.musicPlayer.pause()
                
            }
        }
        
    }
    
    func previousSong(){
        if(PlayerViewController.isPlayerInitialised){
            if(currentSongIndex - 1 >= 0){
                currentSongIndex -= 1
                PlayerViewController.playSong(song: songs[currentSongIndex])
                updateCoverImage()
                updateSongName()
            }
        }
    }
    
    func nextSong(){
        if(PlayerViewController.isPlayerInitialised){
            if(currentSongIndex + 1 < songs.count){
                currentSongIndex += 1
                PlayerViewController.playSong(song: songs[currentSongIndex])
                updateCoverImage()
                updateSongName()
            }
        }
    }
    static func secondsToHoursMinutesSeconds (seconds : Int) -> (String) {
        let (h,m,s) = (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
        if(s < 10){
            return String(m) + ":0" + String(s)
        }else{
            return String(m) + ":" + String(s)
        }
    }

}


extension UIImage {
    func resizeImage(targetSize: CGSize) -> UIImage {
        let size = self.size
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        let newSize = widthRatio > heightRatio ?  CGSize(width: size.width * heightRatio, height: size.height * heightRatio) : CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}
