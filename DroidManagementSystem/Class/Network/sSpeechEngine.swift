//
//  sSpeechEngine.swift
//  DroidManagementSystem
//
//  Created by Peter Spencer on 07/11/2018.
//  Copyright © 2018 Peter Spencer. All rights reserved.
//

import Foundation
import Speech


@objcMembers
class SpeechEngine: NSObject
{
    // MARK: - Property(s)
    
    private(set) dynamic var spoken: String?
    
    private let engine = AVAudioEngine()
    
    private let recognizer: SFSpeechRecognizer? = SFSpeechRecognizer()
    
    private let request = SFSpeechAudioBufferRecognitionRequest()
    
    private var task: SFSpeechRecognitionTask?
    
    
    // MARK: - Utility
    
    static func authorise(completion: @escaping (Bool) -> Void)
    {
        SFSpeechRecognizer.requestAuthorization
        { (authStatus) in
                
            guard authStatus == .authorized else
            {
                completion(false)
                return
            }
            completion(true)
        }
    }
    
    
    // MARK: - Recording
    
    func startRecording()
    {
        // self.request.shouldReportPartialResults = false
        let format = self.engine.inputNode.outputFormat(forBus: 0)
        
        self.engine.inputNode.installTap(onBus: 0,
                                         bufferSize: 1024,
                                         format: format)
        { (buffer, _) in
            
            self.request.append(buffer)
        }
        
        do
        {
            self.engine.prepare()
            try self.engine.start()
        }
        catch {}
        
        self.task = self.recognizer?.recognitionTask(with: request)
        { [weak self] (result, error) in
            
            if result?.isFinal ?? (error != nil)
            { self?.spoken = result?.bestTranscription.formattedString.lowercased() }
        }
    }
    
    func stopRecording()
    {
        if self.engine.isRunning
        {
            self.engine.stop()
            self.engine.inputNode.removeTap(onBus: 0)
            self.request.endAudio()
            self.task?.finish()
        }
    }
}

