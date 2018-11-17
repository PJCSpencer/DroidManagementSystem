//
//  sSpeechCommands.swift
//  DroidManagementSystem
//
//  Created by Peter Spencer on 07/11/2018.
//  Copyright © 2018 Peter Spencer. All rights reserved.
//

import UIKit
import Speech


let SpeechControllerNotification = Notification.Name(rawValue: "com.dms.speechController")

@objcMembers
class SpeechController: UIViewController
{
    // MARK: - Property(s)
    
    var interpreter: ProbeDroidSpeechInterpreter?
    
    private(set) var speechEngine: SpeechEngine = SpeechEngine()
    
    private lazy var alertPanel: AlertPanel =
    { [unowned self] in
        
        let anObject = AlertPanel(frame: UIScreen.main.bounds)
        anObject.imageView.image = UIImage(named: "ProbeDroid-Listen")
        
        self.view.addSubview(anObject)
        return anObject
    }()
    
    
    // MARK: - Cleaning
    
    deinit
    { NotificationCenter.default.removeObserver(self) }
    
    
    // MARK: - Managing the View
    
    override func loadView()
    {
        let speechView = SpeechView(frame: UIScreen.main.bounds)
        speechView.button.isEnabled = false
        speechView.button.addTarget(self,
                                    action: #selector(touchDown(_:)),
                                    for: .touchDown)
        speechView.button.addTarget(self,
                                    action: #selector(touchUpInside(_:)),
                                    for: .touchUpInside)
        self.view = speechView
        self.viewRespectsSystemMinimumLayoutMargins = false
        
        NotificationCenter.default.addObserver(forName: SpeechControllerNotification,
                                               object: nil,
                                               queue: nil,
                                               using: self.probeDroid(_:))
        
        NotificationCenter.default.addObserver(forName: ProbeDroidCRequestNotification,
                                               object: nil,
                                               queue: nil,
                                               using: self.location(_:))
    }
    
    
    // MARK: - Responding to View Events
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
        self.interpreter = ProbeDroidSpeechInterpreter(speechEngine: self.speechEngine)
        
        SpeechEngine.authorise()
        { [weak self] (result) in
        
            if result
            {
                guard let speechView = self?.view as? SpeechView else
                { return }
                
                DispatchQueue.main.async { speechView.button.isEnabled = true }
            }
        }
    }
}

// MARK: - Action(s)
extension SpeechController
{
    @objc func touchDown(_ sender: Any)
    { self.speechEngine.startRecording() }
    
    @objc func touchUpInside(_ sender: Any)
    {
        self.speechEngine.stopRecording()
    }
}

// MARK: - Notification Support
extension SpeechController
{
    @objc func probeDroid(_ notification: Notification) -> Void
    {
        guard let tag = notification.object as? Int else
        {
            self.alertPanel.dismiss({})
            return
        }
        
        self.alertPanel.titleLabel.text = "Droid \(tag ) roger, roger..."
        self.alertPanel.messageLabel.text = "Command: move to x ? y ?"
        self.alertPanel.show()
    }
    
    @objc func location(_ notification: Notification) -> Void
    { 
        if let _ = notification.object { return } // NB:Only support move request.
        
        self.alertPanel.dismiss
        { [weak self] in
            
            self?.alertPanel.titleLabel.text = notification.moveTitle()
            self?.alertPanel.messageLabel.text = notification.moveMessage()
            
            Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false)
            { (timer) in
                
                self?.alertPanel.show()
                
                Timer.scheduledTimer(withTimeInterval: 2.5, repeats: false)
                { (timer) in self?.alertPanel.dismiss({}) }
            }
        }
    }
}

