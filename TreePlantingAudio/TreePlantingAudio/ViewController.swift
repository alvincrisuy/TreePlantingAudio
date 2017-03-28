//
//  ViewController.swift
//  TreePlantingAudio
//
//  Created by Cris Uy on 27/03/2017.
//  Copyright © 2017 Ecosia. All rights reserved.
//

import UIKit
import AVFoundation
import Foundation

class ViewController: UIViewController {
    
    var audioPlayer:AudioPlayer!
    var timer:Timer!
    
    @IBOutlet var tableView:        UITableView!
    @IBOutlet var previousButton:   UIButton!
    @IBOutlet var nextButton:       UIButton!
    @IBOutlet var playPauseButton:  UIButton!
    @IBOutlet var stopButton:       UIButton!
    @IBOutlet var playerSlider:     UISlider!
    @IBOutlet var timeLabel:        UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        audioPlayer = AudioPlayer()
        audioPlayer.delegate = self
        
        let audio0 = AudioItem(filename: "01. Title")
        let audio1 = AudioItem(filename: "02. Everlasting Wanderers")
        let audio2 = AudioItem(filename: "03. Streamside")
        let audio3 = AudioItem(filename: "04. Theme of Prontera")
        let audio4 = AudioItem(filename: "05. Peaceful Forest")
        let audio5 = AudioItem(filename: "06. Tread on the ground")
        let audio6 = AudioItem(filename: "07. Theme of Geffen")
        let audio7 = AudioItem(filename: "08. Plateau")
        let audio8 = AudioItem(filename: "09. Brassy Road")
        let audio9 = AudioItem(filename: "10. Travel")
        let audio10 = AudioItem(filename: "11. Desert")
        let audio11 = AudioItem(filename: "12. Theme of Morroc")
        let audio12 = AudioItem(filename: "13. TeMPorsche")
        let audio13 = AudioItem(filename: "14. You're in ruins")
        let audio14 = AudioItem(filename: "15. Nano East")
        let audio15 = AudioItem(filename: "16. Theme of Payon")
        
        audioPlayer.audioItemList.append(audio0)
        audioPlayer.audioItemList.append(audio1)
        audioPlayer.audioItemList.append(audio2)
        audioPlayer.audioItemList.append(audio3)
        audioPlayer.audioItemList.append(audio4)
        audioPlayer.audioItemList.append(audio5)
        audioPlayer.audioItemList.append(audio6)
        audioPlayer.audioItemList.append(audio7)
        audioPlayer.audioItemList.append(audio8)
        audioPlayer.audioItemList.append(audio9)
        audioPlayer.audioItemList.append(audio10)
        audioPlayer.audioItemList.append(audio11)
        audioPlayer.audioItemList.append(audio12)
        audioPlayer.audioItemList.append(audio13)
        audioPlayer.audioItemList.append(audio14)
        audioPlayer.audioItemList.append(audio15)
        
        audioPlayer.prepareAudio()
        
        updateSelectedRow()
        setPlayerUI()
        startTimer()
    }
    
    @IBAction func previousButtonAction(sender: UIButton) {
        audioPlayer.previousAudio()
        
        updateSelectedRow()
        setPlayerUI()
    }
    
    @IBAction func nextButtonAction(sender: UIButton) {
        audioPlayer.nextAudio()
        
        updateSelectedRow()
        setPlayerUI()
    }
    
    @IBAction func playPauseAction(sender: UIButton) {
        audioPlayer.playPauseAudio()
        
        updatePlayPauseButton()
    }
    
    @IBAction func stopButtonAction(sender: UIButton) {
        audioPlayer.stopAudio()
        
        updateSelectedRow()
        setPlayerUI()
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(updateSlider), userInfo: nil, repeats: true)
        timer.fire()
    }
    
    func updateSelectedRow() {
        
        let indexPath = NSIndexPath(row: audioPlayer.currentAudioIndex, section: 0) as IndexPath
        
        self.tableView.selectRow(at: indexPath, animated: true, scrollPosition: UITableViewScrollPosition.none)
    }
    
    func setPlayerUI() {
        
        playerSlider.minimumValue   = 0.0
        playerSlider.maximumValue   = Float(audioPlayer.currentAudioItem.totalSeconds)
        playerSlider.value          = 0.0
        
        updatePlayPauseButton()
        updateSlider()
    }
    
    func updatePlayPauseButton() {
        
        audioPlayer.audioPlayer.isPlaying ? playPauseButton.setTitle("Pause", for: UIControlState.normal) : playPauseButton.setTitle("Play", for: UIControlState.normal)
        
    }
    
    func updateSlider() {
        
        let hours   = Int(audioPlayer.audioPlayer.currentTime) / 3600
        let minutes = Int(audioPlayer.audioPlayer.currentTime) / 60
        let seconds = Int(audioPlayer.audioPlayer.currentTime) % 60
        
        timeLabel.text = String(format: "%02d:%02d:%02d/%02d:%02d:%02d",
                                hours,
                                minutes,
                                seconds,
                                audioPlayer.currentAudioItem.hours,
                                audioPlayer.currentAudioItem.minutes,
                                audioPlayer.currentAudioItem.seconds)
        
        playerSlider.value = Float(audioPlayer.audioPlayer.currentTime)
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return audioPlayer.audioItemList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let index                   = indexPath.row
        let audioItem               = audioPlayer.audioItemList[index]
        let cell                    = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text        = audioItem.title
        cell.detailTextLabel?.text  = String(format:
            "Duration: %02d:%02d:%02d\nTitle: %@\nArtist: %@\nAlbum: %@\nAuthor: %@",
                                             audioItem.hours,
                                             audioItem.minutes,
                                             audioItem.seconds,
                                             audioItem.title!,
                                             audioItem.artist!,
                                             audioItem.album!,
                                             audioItem.author!)
        cell.detailTextLabel?.numberOfLines = 5
        
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        audioPlayer.playAudioWithIndex(index: indexPath.row)
        
        setPlayerUI()
    }
}

extension ViewController: AudioPlayerDelegate {
    
    func audioPlayerDidFinishPlaying() {
        updateSelectedRow()
    }
    
}
