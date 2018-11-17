//
//  sProbeDroidSpeechInterpreter.swift
//  DroidManagementSystem
//
//  Created by Peter Spencer on 07/11/2018.
//  Copyright © 2018 Peter Spencer. All rights reserved.
//

import Foundation


enum ProbeDroidSpeechKeys
{
    case probeDroidIndex
}

class ProbeDroidSpeechInterpreter // TODO:Refactor to support protocol pool of speech items ...
{
    // MARK: - Property(s)
    
    fileprivate var index: ProbeDroidIndex? // This could be an Int.
    {
        didSet
        {
            NotificationCenter.default.post(name: SpeechControllerNotification,
                                            object: index?.tag)
        }
    }
    
    fileprivate var observation: NSKeyValueObservation?
    
    
    // MARK: - Initialisation
    
    init(speechEngine: SpeechEngine)
    {
        self.observation = speechEngine.observe(\.spoken, options: [.new])
        { [weak self] (object, change) in
            
            guard let newValue = change.newValue,
                let components = newValue?.components(separatedBy: " ") else
            { return }
            
            if self?.index == nil
            { self?.index = self?.index(components) }
            else
            {
                self?.post(self?.index, location: self?.location(components))
                self?.index = nil
            }
        }
    }
    
    deinit
    { self.observation?.invalidate() }
    
    
    // MARK: - Process
    
    func index( _ components: [String]) -> ProbeDroidIndex?
    {
        guard components.count == 3,
            let _ = components.index(where: { $0 == "droid" }),
            let number = components.index(where: { $0 == "number" }),
            number + 1 < components.count else
        { return nil }
        
        let key = components[components.index(after: number)]
        
        guard let tag = Int.from(spoken: key) else
        { return nil }
        
        return ProbeDroidIndex(tag)
    }
    
    func location( _ components: [String]) -> Location?
    {
        guard let i0 = components.index(where: { $0 == "move" }),
            let i1 = components.index(where: { $0 == "to" }),
            i1 == i0+1 else
        { return nil }
        
        let indexes: IndexSet = [i0, i1]
        var buffer = components
        indexes.reversed().forEach { buffer.remove(at: $0) }
        
        let ix = self.coordinate(key: "x", in: buffer)
        let iy = self.coordinate(key: "y", in: buffer)
        
        guard let udx = ix, let udy = iy else
        { return nil }
        
        // TODO:Clamp values between 0 and 1000 ..?
        let cap = 1000
        let dx = udx < 0 ? 0 : udx > cap ? cap : udx
        let dy = udy < 0 ? 0 : udy > cap ? cap : udy
        
        return Location(x: dx, y: dy)
    }
    
    
    // MARK: - Utility
    
    func coordinate(key: String, in components: [String]) -> Int?
    {
        guard let index = components.index(where: { $0.contains(key) }) else
        { return nil }
        
        if index >= components.count-1 // [y2]?
        {
            let buffer = String(components[index].dropFirst())
            
            guard let value = Int.from(spoken: buffer) else
            { return nil }
            
            return value
        }
        
        if index + 1 < components.count,
            let value = Int.from(spoken: components[index+1])   // [y, 2]?
        { return value }
        
        return nil
    }
    
    
    // MARK: - Notification Support
    
    func post(_ index: ProbeDroidIndex?, location: Location?)
    {
        var userInfo: RequestArgs!
        
        if let index = index, let location = location
        {
            userInfo =
            [
                ProbeDroidIndex.Keys.index.rawValue : index,
                Location.Keys.location.rawValue     : location
            ]
        }
        
        NotificationCenter.default.post(name: ProbeDroidCRequestNotification,
                                        object: nil,
                                        userInfo: userInfo)
    }
}

