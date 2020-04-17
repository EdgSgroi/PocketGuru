//
//  MasterViewController.swift
//  Master's Advices
//
//  Created by Edgar Sgroi on 16/04/20.
//  Copyright © 2020 Edgar Sgroi. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class MasterViewController: UIViewController {
    
    @IBOutlet weak var imgMaster: UIImageView!
    @IBOutlet weak var lblAdvice: UILabel!
    @IBOutlet weak var btnAdviceRequest: UIButton!
    @IBOutlet weak var imgSmoke: UIImageView!
    @IBOutlet weak var txtFromButton: UILabel!
    var soundTrack: AVAudioPlayer?
    var guruVoice: AVAudioPlayer?
    let viewModel: ViewModel = ViewModel()
    
    var masterIsSetted: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playSoundTrack()
        NotificationCenter.default.addObserver(self, selector: #selector(changeAdvice), name: .updateAdvice, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.lblAdvice.isHidden = true
        self.imgMaster.alpha = CGFloat(0.0)
//        guruEntranceAnimation()
        addParallaxToView(vw: imgMaster)
    }
    
    @IBAction func newAdvice(_ sender: Any) {
        if masterIsSetted {
            viewModel.adviceRequest()
            btnAdviceRequest.isEnabled = false
        } else {
            guruEntranceAnimation()
            masterIsSetted = true
        }
    }
    
    @objc func changeAdvice() {
        lblAdvice.text = viewModel.advice
        faceAnimation()
        smokeAnimation()
        playGuruVoice(resourceName: "GuruVoice")
        btnAdviceRequest.isEnabled = true
    }
    
    func faceAnimation() {
        _ = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false, block: {
            [weak self] _ in
            self?.imgMaster.image = #imageLiteral(resourceName: "Master1.2")
            Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false, block: {
                [weak self] _ in
                self?.imgMaster.image = #imageLiteral(resourceName: "Master1.3")
                Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false, block: {
                    [weak self] _ in
                    self?.imgMaster.image = #imageLiteral(resourceName: "Master1.1")
                    
                })
            })
        })
    }
    
    func smokeAnimation() {
        self.imgSmoke.alpha = CGFloat(1.0)
        UIView.animate(withDuration: 1.0, delay: 0.0, options: [.transitionCrossDissolve, .transitionCurlDown], animations: {
//            self.imgSmoke.image =
            self.imgSmoke.alpha = CGFloat(0.0)
        }, completion: nil)
    }
    
    func playSoundTrack() {
        let path = Bundle.main.path(forResource: "PocketGuruSoundTrack", ofType: "mp3")!
        let url = URL(fileURLWithPath: path)

        do {
            soundTrack = try AVAudioPlayer(contentsOf: url)
            soundTrack?.numberOfLoops = -1
            soundTrack?.play()
        } catch {
            // couldn't load file :(
        }
    }
    
    func playGuruVoice(resourceName: String) {
        let path = Bundle.main.path(forResource: resourceName, ofType: "mp3")!
        let url = URL(fileURLWithPath: path)

        do {
            guruVoice = try AVAudioPlayer(contentsOf: url)
            guruVoice?.play()
        } catch {
            // couldn't load file :(
        }
    }
    
    func addParallaxToView(vw: UIView) {
        let amount = 150

        let horizontal = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
        horizontal.minimumRelativeValue = -amount
        horizontal.maximumRelativeValue = amount

        let vertical = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
        vertical.minimumRelativeValue = -amount
        vertical.maximumRelativeValue = amount

        let group = UIMotionEffectGroup()
        group.motionEffects = [horizontal, vertical]
        vw.addMotionEffect(group)
    }
    
    func guruEntranceAnimation() {
        playGuruVoice(resourceName: "GuruVoice2")
        self.btnAdviceRequest.isEnabled = false
                UIView.animate(withDuration: 2.0, delay: 0.0, options: [.transitionCrossDissolve, .transitionCurlDown], animations: {
        //            self.imgSmoke.image =
                    self.imgMaster.alpha = CGFloat(1.0)
                }, completion: {
                finished in
                    if finished {
                        self.lblAdvice.isHidden = false
                        self.btnAdviceRequest.isEnabled = true
                        self.txtFromButton.text = "Give me your knowledge, master!"
                    }
                })
    }
}
