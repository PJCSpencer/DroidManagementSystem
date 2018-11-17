//
//  sMockedDCS.swift
//  DroidManagementSystem
//
//  Created by Peter Spencer on 04/11/2018.
//  Copyright © 2018 Peter Spencer. All rights reserved.
//

import Foundation


let DCSNotification = Notification.Name(rawValue: "com.dcs.notify")

class MockedProbeDroid
{
    var index: Int
    var status: ProbeDroidStatus = .online
    var location: Location = Location(x: 0, y: 0)
    var targetLocation: Location = Location(x: 0, y: 0)
    var detection: Detection = Detection(false)
    
    init(_ tag: Int, location: Location)
    {
        self.index = tag
        self.location = location
    }
    
    init(_ tag: Int, status: ProbeDroidStatus, location: Location)
    {
        self.index = tag
        self.status = status
        self.location = location
    }
}

class MockedDCS
{
    static let scale: Int = 1000
    
    static let r2d2Location: Location = Location(x: 500, y: 500)
    
    static let numberOfProbeDroids: Int = 10
    
    static var data: [MockedProbeDroid] =
    {
        var buffer: [MockedProbeDroid] = []
        for i in 0...MockedDCS.numberOfProbeDroids-1
        {
            buffer.append(MockedProbeDroid(i, location: Location.random(MockedDCS.scale)))
        }
        return buffer
    }()
    
    typealias DCSHandler = (Data) -> Void
    
    static let handlers: [String:DCSHandler] =
    [
        "count"     : MockedDCS.count,
        "move"      : MockedDCS.move,
        "status"    : MockedDCS.status
    ]
    
    static func doSomething(_ data: Data)
    {
        guard let json = JSONSerialization.object(with: data),
            let command =  json[ProbeDroidCommand.Keys.command.rawValue] as? String,
            let handler = MockedDCS.handlers[command] else
        {
            MockedDCS.error()
            return
        }
        handler(data)
    }
    
    static func mockedProbeDroid(_ data: Data) -> MockedProbeDroid?
    {
        guard let json = JSONSerialization.object(with: data),
            let args = json[ProbeDroidCommand.Keys.args.rawValue] as? RequestArgs else
        { return nil }
        
        let index = args[ProbeDroidIndex.Keys.index.rawValue] as? Int ?? 0
        
        return self.data[index]
    }
    
    static func location(_ data: Data) -> Location?
    {
        guard let json = JSONSerialization.object(with: data),
            let args = json[ProbeDroidCommand.Keys.args.rawValue] as? RequestArgs else
        { return nil }
        
        return Location(args)
    }
}

