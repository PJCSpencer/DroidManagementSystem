//
//  sProbeDroidMoveCordinator.swift
//  DroidManagementSystem
//
//  Created by Peter Spencer on 06/11/2018.
//  Copyright © 2018 Peter Spencer. All rights reserved.
//

import Foundation


typealias ProbeDroidMoveCordinatorHandler = (ProbeDroid) -> Void

class ProbeDroidMoveCordinator // TODO:Support protocol ..?
{
    // MARK: - Property(s)
    
    weak var detection: DetectionCoordinator?
    
    fileprivate lazy var handlers: [Int:ProbeDroidMoveCordinatorHandler] =
    { [unowned self] in
        
        return [ProbeDroidStatus.pending.rawValue       : self.begin,
                ProbeDroidStatus.acknowledged.rawValue  : self.acknowledge,
                ProbeDroidStatus.mobile.rawValue        : self.update,
                ProbeDroidStatus.achieved.rawValue      : self.end]
    }()
    
    fileprivate var observation: NSKeyValueObservation?
    
    fileprivate var destination: Location
    
    
    // MARK: - Initialisation
    
    init(_ probeDroid: ProbeDroid, destination location: Location)
    {
        self.destination = location // NB:Could capture in function.
        
        self.observation = probeDroid.observe(\.status, options: [.new])
        { (object, change) in
            
            if let key = change.newValue,
                let handler = self.handlers[key]
            { handler(object) }
        }
    }
    
    deinit
    { self.observation?.invalidate() }
    
    
    // MARK: - Process
    
    fileprivate func begin(_ probeDroid: ProbeDroid) {}
    
    fileprivate func acknowledge(_ probeDroid: ProbeDroid) {}
    
    fileprivate func update(_ probeDroid: ProbeDroid)
    {
        guard probeDroid.status == ProbeDroidStatus.mobile.rawValue else
        { return }
        
        // TODO:Query detection, play r2d2 audio hint ...
        
        
        let params = StatusParameter(index: probeDroid.index)
        let request = ProbeDroidRequest(command: .status, parameter: params)
        
        NotificationCenter.default.post(name: ProbeDroidCRequestNotification,
                                        object: request)
    }
    
    fileprivate func end(_ probeDroid: ProbeDroid)
    { 
        self.observation?.invalidate()
        
        probeDroid.status = ProbeDroidStatus.online.rawValue
        
        self.detection?.detect(probeDroid.detection,
                               in: probeDroid.location)
    }
}

