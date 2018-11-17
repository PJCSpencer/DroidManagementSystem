//
//  sProbeDroid-ext.swift
//  DroidManagementSystem
//
//  Created by Peter Spencer on 06/11/2018.
//  Copyright © 2018 Peter Spencer. All rights reserved.
//

import Foundation


let ProbeDroidCRequestNotification = Notification.Name(rawValue: "com.dms.probeDroidRequest")

extension ProbeDroid
{
    func update(_ probeDroid: ProbeDroid)
    { 
        self.location = probeDroid.location
        self.detection = probeDroid.detection
        self.status = probeDroid.status // NB:Order is significant.
    }
    
    
    // MARK: - Print Utility
    
    func log()
    {
        print("""
            \(String(describing: self.index.tag)), \(self.status), \(self.detection.state),
            \(String(describing: self.location.x)):\(String(describing: self.location.y))\n
            """)
    }
}

// MARK: - Notification Support
extension Notification // NB:This had to be inverse to work, odd?
{
    func moveRequest() -> ProbeDroidRequest<MoveParameters>?
    {
        guard let userInfo = self.userInfo,
            let index = userInfo[ProbeDroidIndex.Keys.index.rawValue] as? ProbeDroidIndex,
            let location = userInfo[Location.Keys.location.rawValue] as? Location else
        { return nil }
        
        let params = MoveParameters(index: index, location: location)
        let request = ProbeDroidRequest(command: ProbeDroidCommand.move, parameter: params)
        return request
    }
    
    func moveTitle() -> String
    {
        guard let userInfo = self.userInfo,
            let _ = userInfo[Location.Keys.location.rawValue] as? Location else
        { return "interruption???".uppercased() }
        
        return "affirmative!!!".uppercased()
    }
    
    func moveMessage() -> String
    {
        guard let userInfo = self.userInfo,
            let location = userInfo[Location.Keys.location.rawValue] as? Location else
        { return "Please confirm my master..." }
        
        return "Relocating to sector x:\(location.x) y:\(location.y)"
    }
}

