//
//  sLocation.swift
//  DMS
//
//  Created by Peter Spencer on 11/11/2018.
//  Copyright © 2018 Peter Spencer. All rights reserved.
//

import Foundation


final class Location: NSObject, ProbeDroidRequestArgs
{
    enum Keys: String
    {
        case location
        case x, y
    }
    
    let x: Int
    let y: Int
    
    init(x: Int, y: Int)
    {
        self.x = x
        self.y = y
    }
    
    init(_ args: RequestArgs)
    {
        var x: Int = 0
        var y: Int = 0
        
        if let location = args[Keys.location.rawValue] as? [String:Int]
        {
            x = location[Keys.x.rawValue] ?? 0
            y = location[Keys.y.rawValue] ?? 0
        }
        
        self.x = x
        self.y = y
    }
    
    func args() -> RequestArgs
    { return [Keys.location.rawValue: [Keys.x.rawValue:self.x, Keys.y.rawValue:self.y]] }
}

extension Location
{
    static func random(_ scale: Int) -> Location
    {
        return Location(x: Int.random(in: 0...scale),
                        y: Int.random(in: 0...scale))
    }
    
    func isLocationEqual(_ target: Location) -> Bool
    { return (self.x == target.x && self.y == target.y) }
}

