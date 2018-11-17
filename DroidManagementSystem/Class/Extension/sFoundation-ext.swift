//
//  sFoundation-ext.swift
//  DroidManagementSystem
//
//  Created by Peter Spencer on 02/11/2018.
//  Copyright © 2018 Peter Spencer. All rights reserved.
//

import Foundation


extension Int
{
    private static let unitTable: [String:Int] = ["zero":0, "one":1, "two":2, "three":3, "four":4, "five":5, "six":6, "seven":7, "eight":8, "nine":9]
    
    private static let predefinedTable: [String:Int] = Int.unitTable.merging( ["to":2, "too":2, "for":4] ) { $1 }
    
    static func from(spoken: String,
                     with predefinedContext: Bool = true) -> Int?
    { 
        let lowercased = spoken.lowercased()
        
        if let str = lowercased.first, let n = Int(String(str)), (0...9).contains(n)
        { return Int(spoken) }
        
        let lookup = predefinedContext ? Int.predefinedTable : Int.unitTable
        
        if let count = lookup.keys.max(by: { $1.count > $0.count })?.count,
            spoken.count > count
        { return nil }
        
        guard let n = lookup[lowercased] else
        { return nil }
        
        return n
    }
}

extension String
{
    static var intro: String
    {
        return """
        Luke Skywalker has vanished. In his absence, the sinister First Order has risen from the ashes of the Empire and will not rest until Skywalker, the last Jedi, has been destroyed.
        
        
        With the support of the republic, General Leia Organa leads a brave resistance. She is desperate to find her brother Luke and enlist his help to restore peace and justice to the galaxy.
        
        
        Rumours have spread that Luke sent the droid R2-D2 on a secret reconnaissance mission to Korriban at the outer rim of the galaxy. It is imperative that the resistance retrieve R2-D2 in the hopes that the droid is carrying information regarding the whereabouts of Luke Skywalker.
        
        
        General Organa has tasked the resistance engineering team to develop a software system capable of communicating with probe droids to be dispatched to the planet Korriban in search of the R2 unit...
        """
    }
}

