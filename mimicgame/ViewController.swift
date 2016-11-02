//
//  ViewController.swift
//  mimicgame
//
//  The idea behind this game is to use RNG to open the chests.
//  Opening the chest has a chance of spawning a mimic.
//  Mimics render the chest useless, so raise your score with the other chests.
//  
//  Created by Wellison Pereira on 8/4/16.
//  Copyright © 2016 Tora Cross. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    //Outlets
    @IBOutlet weak var gameScoreLbl: UILabel!
    @IBOutlet weak var resultImg: UIImageView!
    @IBOutlet weak var chestOne: UIButton!
    @IBOutlet weak var chestTwo: UIButton!
    @IBOutlet weak var chestThree: UIButton!
    @IBOutlet weak var resetBtn: UIButton!
    @IBOutlet weak var musicBtn: UIButton!
    
    var musicPlayer = AVAudioPlayer()
    var sfxMimic = AVAudioPlayer()
    var sfxChest = AVAudioPlayer()
    var scoreCounter = 0
    var timer = Timer()
    let closedTC = UIImage(named: "closedTC") as UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            try musicPlayer = AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "bgTheme", ofType: "mp3")!))
            try sfxMimic = AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "mimicSpawn", ofType: "wav")!))
            try sfxChest = AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "chestOpened", ofType: "wav")!))
            
            musicPlayer.prepareToPlay()
            musicPlayer.play()
            musicPlayer.volume = 0.3
            musicPlayer.numberOfLoops = -1
            
            sfxChest.prepareToPlay()
            sfxChest.volume = 0.2
            sfxMimic.prepareToPlay()
            sfxMimic.volume = 0.6
            
        } catch let err as NSError {
            print(err.description)
        }
    }
    
    @IBAction func musicBtnPressed(_ sender: UIButton!) {
        if musicPlayer.isPlaying {
            musicPlayer.stop ()
            sender.alpha = 0.2
        } else {
            musicPlayer.play()
            sender.alpha = 1.0
        }
    }
    
    @IBAction func chestOnePressed(_ sender: AnyObject) {
        mimicRollOne()
        
    }
    
    @IBAction func chestTwoPressed(_ sender: AnyObject) {
        mimicRollTwo()
    }
    

    @IBAction func chestThreePressed(_ sender: AnyObject) {
        mimicRollThree()
    }
    
    func mimicRollOne() {
        let roll1 = arc4random_uniform(12)
        
        if roll1 >= 2 {
            let treasureImage = UIImage(named: "openedTC") as UIImage!
            chestOne.setImage(treasureImage, for: UIControlState())
            resultImg.image = UIImage(named: "treasureLogo")
            resultImg.isHidden = false
            chestOne.isEnabled = false
            chestTwo.isEnabled = false
            chestThree.isEnabled = false
            sfxChest.play()
            updateScore()
            let chestOneTimer = DispatchTime.now() + 0.5
            DispatchQueue.main.asyncAfter(deadline: chestOneTimer) {
                self.resultImg.isHidden = true
                self.chestOne.setImage(self.closedTC, for: UIControlState())
                self.chestOne.isEnabled = true
                
                //Prevent chest spam
                if self.chestTwo.currentImage == UIImage(named: "mimicTC") && self.chestThree.currentImage == UIImage(named: "mimicTC") {
                    self.chestTwo.isEnabled = false
                    self.chestThree.isEnabled = false
                } else if self.chestTwo.currentImage == UIImage(named: "mimicTC") && self.chestThree.currentImage == UIImage(named: "closedTC") {
                    self.chestTwo.isEnabled = false
                    self.chestThree.isEnabled = true
                } else if self.chestTwo.currentImage == UIImage(named: "closedTC") && self.chestThree.currentImage == UIImage(named: "closedTC") {
                    self.chestTwo.isEnabled = true
                    self.chestThree.isEnabled = true
                } else if self.chestTwo.currentImage == UIImage(named: "closedTC") && self.chestThree.currentImage == UIImage(named: "mimicTC") {
                    self.chestTwo.isEnabled = true
                    self.chestThree.isEnabled = false
                }
                
            }
        } else {
            let mimicOne = UIImage(named: "mimicTC") as UIImage!
            chestOne.setImage(mimicOne, for: UIControlState())
            resultImg.image = UIImage(named: "mimicLogo")
            resultImg.isHidden = false
            chestOne.isEnabled = false
            sfxMimic.play()
            gameOver()
            let mimicOneTimer = DispatchTime.now() + 0.5
            DispatchQueue.main.asyncAfter(deadline: mimicOneTimer) {
                self.resultImg.isHidden = true
            }
        }
    }
    
    func mimicRollTwo() {
        let roll2 = arc4random_uniform(12)
        
        if roll2 >= 2 {
            let treasureImage = UIImage(named: "openedTC") as UIImage!
            chestTwo.setImage(treasureImage, for: UIControlState())
            resultImg.image = UIImage(named: "treasureLogo")
            resultImg.isHidden = false
            chestOne.isEnabled = false
            chestTwo.isEnabled = false
            chestThree.isEnabled = false
            sfxChest.play()
            updateScore()
            let chestTwoTimer = DispatchTime.now() + 0.5
            DispatchQueue.main.asyncAfter(deadline: chestTwoTimer) {
                self.resultImg.isHidden = true
                self.chestTwo.setImage(self.closedTC, for: UIControlState())
                self.chestTwo.isEnabled = true
                
                if self.chestOne.currentImage == UIImage(named: "mimicTC") && self.chestThree.currentImage == UIImage(named: "mimicTC") {
                    self.chestOne.isEnabled = false
                    self.chestThree.isEnabled = false
                } else if self.chestOne.currentImage == UIImage(named: "mimicTC") && self.chestThree.currentImage == UIImage(named: "closedTC") {
                    self.chestOne.isEnabled = false
                    self.chestThree.isEnabled = true
                } else if self.chestOne.currentImage == UIImage(named: "closedTC") && self.chestThree.currentImage == UIImage(named: "closedTC") {
                    self.chestOne.isEnabled = true
                    self.chestThree.isEnabled = true
                } else if self.chestOne.currentImage == UIImage(named: "closedTC") && self.chestThree.currentImage == UIImage(named: "mimicTC") {
                    self.chestOne.isEnabled = true
                    self.chestThree.isEnabled = false
                }
            }
        } else {
            let mimicTwo = UIImage(named: "mimicTC") as UIImage!
            chestTwo.setImage(mimicTwo, for: UIControlState())
            resultImg.image = UIImage(named: "mimicLogo")
            resultImg.isHidden = false
            chestTwo.isEnabled = false
            sfxMimic.play()
            gameOver()
            let mimicTwoTimer = DispatchTime.now() + 0.5
            DispatchQueue.main.asyncAfter(deadline: mimicTwoTimer) {
                self.resultImg.isHidden = true
            }
        }
    }
    
    func mimicRollThree() {
        let roll3 = arc4random_uniform(12)
        if roll3 >= 2 {
            let treasureImage = UIImage(named: "openedTC") as UIImage!
            chestThree.setImage(treasureImage, for: UIControlState())
            resultImg.image = UIImage(named: "treasureLogo")
            resultImg.isHidden = false
            chestOne.isEnabled = false
            chestTwo.isEnabled = false
            chestThree.isEnabled = false
            sfxChest.play()
            updateScore()
            let chestThreeTimer = DispatchTime.now() + 0.5
            DispatchQueue.main.asyncAfter(deadline: chestThreeTimer) {
                self.resultImg.isHidden = true
                self.chestThree.setImage(self.closedTC, for: UIControlState())
                self.chestThree.isEnabled = true
                
                if self.chestOne.currentImage == UIImage(named: "mimicTC") && self.chestTwo.currentImage == UIImage(named: "mimicTC") {
                    self.chestOne.isEnabled = false
                    self.chestTwo.isEnabled = false
                } else if self.chestOne.currentImage == UIImage(named: "mimicTC") && self.chestTwo.currentImage == UIImage(named: "closedTC") {
                    self.chestOne.isEnabled = false
                    self.chestTwo.isEnabled = true
                } else if self.chestOne.currentImage == UIImage(named: "closedTC") && self.chestTwo.currentImage == UIImage(named: "closedTC") {
                    self.chestOne.isEnabled = true
                    self.chestTwo.isEnabled = true
                } else if self.chestOne.currentImage == UIImage(named: "closedTC") && self.chestTwo.currentImage == UIImage(named: "mimicTC") {
                    self.chestOne.isEnabled = true
                    self.chestTwo.isEnabled = false
                }
            }
        } else {
            let mimicThree = UIImage(named: "mimicTC") as UIImage!
            chestThree.setImage(mimicThree, for: UIControlState())
            resultImg.image = UIImage(named: "mimicLogo")
            resultImg.isHidden = false
            chestThree.isEnabled = false
            sfxMimic.play()
            gameOver()
            let mimicThreeTimer = DispatchTime.now() + 0.5
            DispatchQueue.main.asyncAfter(deadline: mimicThreeTimer) {
                self.resultImg.isHidden = true
            }
        }
    }
    
    
    @IBAction func resetBtnPressed(_ sender: AnyObject) {
        resetGame()
        resultImg.isHidden = true
        gameScoreLbl.text = "0"
        scoreCounter = 0
    }
    
    
    func gameOver() {
        if chestOne.isEnabled == false && chestTwo.isEnabled == false && chestThree.isEnabled == false {
            let time = DispatchTime.now() + 0.5
            DispatchQueue.main.asyncAfter(deadline: time) {
                self.resetBtn.isHidden = false
            }
        }
    }
    
    func resetGame() {
        chestOne.isEnabled = true
        chestTwo.isEnabled = true
        chestThree.isEnabled = true
        
        
        chestOne.setImage(closedTC, for: UIControlState())
        chestTwo.setImage(closedTC, for: UIControlState())
        chestThree.setImage(closedTC, for: UIControlState())
        
        resetBtn.isHidden = true
    }
    
    func updateScore() {
        scoreCounter = scoreCounter + 1
        gameScoreLbl.text = "\(scoreCounter)"
    }
}

