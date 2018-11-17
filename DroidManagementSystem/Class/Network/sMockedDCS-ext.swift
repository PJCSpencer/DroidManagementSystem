//
//  sMockedDCS-ext.swift
//  DroidManagementSystem
//
//  Created by Peter Spencer on 06/11/2018.
//  Copyright © 2018 Peter Spencer. All rights reserved.
//

import Foundation


extension MockedDCS
{
    static func count(_ data: Data)
    {
        let parameter = IntParameter(value: MockedDCS.data.count)
        guard let data = ProbeDroidRequest(command: .count, parameter: parameter).data() else
        { return }
        
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + TimeInterval.random(in: 0.5..<5))
        {
            NotificationCenter.default.post(name: DCSNotification,
                                            object: data)
        }
    }
}

extension MockedDCS
{
    static func move(_ data: Data) // Location == destination.
    {
        guard let mockedProbeDroid = MockedDCS.mockedProbeDroid(data),
            let targetLocation = MockedDCS.location(data) else
        { return }
        
        if mockedProbeDroid.status == .mobile
        {
            self.status(data)
            return
        }
        
        mockedProbeDroid.status = .mobile
        mockedProbeDroid.targetLocation = targetLocation
        
        self.acknowledge(mockedProbeDroid)
    }
    
    static func acknowledge(_ mockedProbeDroid: MockedProbeDroid)
    {
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + TimeInterval.random(in: 0.5..<3))
        {
            let args: RequestArgs =
            [
                ProbeDroidIndex.Keys.index.rawValue     : mockedProbeDroid.index,
                ProbeDroidStatus.Keys.status.rawValue   : ProbeDroidStatus.acknowledged.rawValue,
                Location.Keys.location.rawValue         : ["x" : mockedProbeDroid.location.x,
                                                           "y" : mockedProbeDroid.location.y],
                Detection.Keys.detection.rawValue       : false
            ]
            
            let data = [ProbeDroidCommand.Keys.command.rawValue:ProbeDroidCommand.move.rawValue,
                        ProbeDroidCommand.Keys.args.rawValue:args].data()
            
            NotificationCenter.default.post(name: DCSNotification,
                                            object: data)
        }
    }
    
    static func complete(_ mockedProbeDroid: MockedProbeDroid)
    {
        mockedProbeDroid.status = .online
        mockedProbeDroid.location = mockedProbeDroid.targetLocation
        mockedProbeDroid.detection = Detection(MockedDCS.r2d2Location.isLocationEqual(mockedProbeDroid.location))

        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + TimeInterval.random(in: 0.5..<3))
        {
            let args: RequestArgs =
            [
                ProbeDroidIndex.Keys.index.rawValue     : mockedProbeDroid.index,
                ProbeDroidStatus.Keys.status.rawValue   : ProbeDroidStatus.achieved.rawValue,
                Location.Keys.location.rawValue         : ["x" : mockedProbeDroid.location.x,
                                                           "y" : mockedProbeDroid.location.y],
                Detection.Keys.detection.rawValue       : mockedProbeDroid.detection.state
            ]
            
            let data = [ProbeDroidCommand.Keys.command.rawValue:ProbeDroidCommand.move.rawValue,
                        ProbeDroidCommand.Keys.args.rawValue:args].data()
            
            NotificationCenter.default.post(name: DCSNotification,
                                            object: data)
        }
    }
}

extension MockedDCS
{
    static func status(_ data: Data)
    {
        guard let mockedProbeDroid = MockedDCS.mockedProbeDroid(data) else
        { return }
        
        if mockedProbeDroid.status == .mobile // TODO:Support function ...
        {
            let lx: Int = Int(mockedProbeDroid.targetLocation.x - mockedProbeDroid.location.x)
            let ly: Int = Int(mockedProbeDroid.targetLocation.y - mockedProbeDroid.location.y)
            
            let scale: Float = 0.25
            let dx = Float(lx) * scale
            let dy = Float(ly) * scale
            
            mockedProbeDroid.location = Location(x: mockedProbeDroid.location.x + Int(dx),
                                                 y: mockedProbeDroid.location.y + Int(dy))
            
            let dim: Int = 10
            let clamp: ClosedRange = (-dim...dim)
            if clamp.contains(lx) && clamp.contains(ly)
            {
                MockedDCS.complete(mockedProbeDroid)
                return
            }
        }
        
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + TimeInterval.random(in: 0.5..<3))
        {
            let args: RequestArgs =
            [
                ProbeDroidIndex.Keys.index.rawValue     : mockedProbeDroid.index,
                ProbeDroidStatus.Keys.status.rawValue   : mockedProbeDroid.status.rawValue,
                Location.Keys.location.rawValue         : ["x" : mockedProbeDroid.location.x,
                                                           "y" : mockedProbeDroid.location.y],
                Detection.Keys.detection.rawValue       : MockedDCS.r2d2Location.isLocationEqual(mockedProbeDroid.location)
            ]
            
            let data = [ProbeDroidCommand.Keys.command.rawValue:ProbeDroidCommand.status.rawValue,
                        ProbeDroidCommand.Keys.args.rawValue:args].data()
            
            NotificationCenter.default.post(name: DCSNotification,
                                            object: data)
        }
    }
}

extension MockedDCS
{
    static func error()
    {
        guard let data = ProbeDroidRequest(command: .count, parameter: NullParameter()).data() else
        { return }
        
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + TimeInterval.random(in: 0..<5))
        {
            NotificationCenter.default.post(name: DCSNotification,
                                            object: data)
        }
    }
}

