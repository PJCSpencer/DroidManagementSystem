//
//  sProbeDroidDataSourceObject.swift
//  DroidManagementSystem
//
//  Created by Peter Spencer on 09/11/2018.
//  Copyright © 2018 Peter Spencer. All rights reserved.
//

import Foundation


class ProbeDroidDataSourceObject
{
    // MARK: - Property(s)
    
    var coordinator: ProbeDroidMoveCordinator?
    {
        didSet
        {
            guard let _ = coordinator else
            { return }
            
            self.probeDroid.status = ProbeDroidStatus.pending.rawValue
        }
    }
    
    private(set) var probeDroid: ProbeDroid
    
    
    // MARK: - Initialisation
    
    init(_ probeDroid: ProbeDroid)
    { self.probeDroid = probeDroid }
}

