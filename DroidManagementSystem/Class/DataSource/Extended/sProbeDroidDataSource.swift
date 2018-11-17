//
//  sProbeDroidDataSource.swift
//  DroidManagementSystem
//
//  Created by Peter Spencer on 04/11/2018.
//  Copyright © 2018 Peter Spencer. All rights reserved.
//

import UIKit


class ProbeDroidDataSource: TableViewDataSource
{
    weak var refreshDelegate: DataSourceRefresh?
    
    var dms: (MockedDMS & ProbeDroidRemoteRequest)? // Too strong? Should be bound only to protocol?
    {
        didSet
        {
            dms?.delegate = self
            dms?.serverSockets = ServerSockets()
        }
    }
    
    deinit
    { NotificationCenter.default.removeObserver(self) }
    
    
    // MARK: - Utility
    
    func object(_ index: ProbeDroidIndex) -> ProbeDroidDataSourceObject?
    {
        guard let section = self.section(at: 0) as? ProbeDroidDataSourceSection,
            let object = section.objects.filter({ $0.probeDroid.index.tag == index.tag }).first else
        { return nil }
        
        return object
    }
    
    func update(_ probeDroid: ProbeDroid)
    {
        guard let object = self.object(probeDroid.index) else
        { return }
        
        object.probeDroid.update(probeDroid)
        
        let indexPath = IndexPath(row: probeDroid.index.tag, section: 0)
        self.refreshDelegate?.dataSource(self, reload: [indexPath])
    }
}

