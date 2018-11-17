//
//  sProbeDroidDetectionCoordinator.swift
//  DroidManagementSystem
//
//  Created by Peter Spencer on 11/11/2018.
//  Copyright © 2018 Peter Spencer. All rights reserved.
//

import Foundation


protocol DetectionCoordinator: class
{
    func detect(_ detection: Detection, in location: Location)
}

struct Detection: ProbeDroidRequestArgs
{
    enum Keys: String
    {
        case detection, state
    }
    
    let state: Bool
    
    init(_ state: Bool)
    { self.state = state }
    
    init(_ args: RequestArgs)
    {
        if let state = args[Keys.detection.rawValue] as? Bool
        { self.state = state }
        else { self.state = false }
    }
    
    func args() -> RequestArgs
    { return [Keys.detection.rawValue: self.state] }
}

class ProbeDroidDetectionCoordinator {}

