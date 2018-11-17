//
//  sProbeDroidDataSource-ext.swift
//  DMS
//
//  Created by Peter Spencer on 11/11/2018.
//  Copyright © 2018 Peter Spencer. All rights reserved.
//

import Foundation


// MARK: - ProbeDroidRemoteResponse
extension ProbeDroidDataSource: ProbeDroidRemoteResponse
{
    func numberOfProbeDroids(_ count: Int)
    {
        guard let section = self.section(at: 0) as? ProbeDroidDataSourceSection else
        { return }
        
        let numberOfProbeDroids: Int = count-1
        
        for i in 0...numberOfProbeDroids
        {
            let object = ProbeDroidDataSourceObject(ProbeDroid(i))
            section.objects.append(object)
            
            let params = StatusParameter(index: ProbeDroidIndex(i))
            let request = ProbeDroidRequest(command: .status, parameter: params)
            self.dms?.status(request)
        }
        
        let indexPath = Array(0...numberOfProbeDroids).map { IndexPath(item: $0, section: 0) }
        self.refreshDelegate?.dataSource(self, insert: indexPath)
        
        NotificationCenter.default.addObserver(forName: ProbeDroidCRequestNotification,
                                               object: nil,
                                               queue: nil,
                                               using: self.notification(_:))
    }
    
    func probeDroidMoveChange(_ probeDroid: ProbeDroid)
    {  self.update(probeDroid) }
    
    func probeDroidStatusChange(_ probeDroid: ProbeDroid)
    { self.update(probeDroid) }
}

// MARK: - Notification Support
extension ProbeDroidDataSource
{
    @objc func notification(_ notification: Notification) -> Void
    {
        if let request = notification.moveRequest(),
            let object = self.object(request.parameter.index)
            /* object.probeDroid.status != ProbeDroidStatus.mobile.rawValue */
        {
            object.coordinator = ProbeDroidMoveCordinator(object.probeDroid,
                                                          destination: request.parameter.location)
            object.coordinator?.detection = self
            
            self.dms?.move(request)
            
            let indexPath = IndexPath(row: request.parameter.index.tag, section: 0)
            self.refreshDelegate?.dataSource(self, reload: [indexPath])
        }
        else if let request = notification.object as? ProbeDroidRequest<StatusParameter>
        {
            self.dms?.status(request)
        }
    }
}

// MARK: - DetectionCoordinator
extension ProbeDroidDataSource: DetectionCoordinator
{
    func detect(_ detection: Detection, in location: Location)
    { print("\(self)::\(#function), \(detection.state), \(location.x):\(location.y)")
        
        /*if let i = section.objects.firstIndex(where: {
         
            $0.probeDroid.location.x >= object.probeDroid.location.x
                && $0.probeDroid.location.y >= object.probeDroid.location.y
                && $0.probeDroid.status != object.probeDroid.status })
         { print("closest index:\(i)") }*/
    }
}

