//
//  sJSONSerialization-ext.swift
//  DroidManagementSystem
//
//  Created by Peter Spencer on 05/11/2018.
//  Copyright © 2018 Peter Spencer. All rights reserved.
//

import Foundation


public typealias JSONObject = [String:Any]

extension JSONSerialization
{
    static func object(with data: Data) -> JSONObject?
    {
        if data.isEmpty { return nil }
        do
        {
            let result = try JSONSerialization.jsonObject(with: data,
                                                          options: .allowFragments) as? JSONObject ?? [:]
            return result
        }
        catch _ { return nil }
    }
}

extension Dictionary where Key == String
{
    func data() -> Data?
    {
        do
        {
            let result = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            return result
        }
        catch _ { return nil }
    }
}

