//
//  sTableViewDataSource.swift
//  DroidManagementSystem
//
//  Created by Peter Spencer on 04/11/2018.
//  Copyright © 2018 Peter Spencer. All rights reserved.
//

import UIKit


class TableViewDataSource: DataSource {}

// MARK: - DataSourceRegistered Protocol
extension TableViewDataSource: DataSourceRegistered
{
    func register(_ dataView: UITableView)
    {
        dataView.dataSource = self
        dataView.delegate = self

        for section in self.allSections()
        {
            dataView.register(section.cellClass.self,
                              forCellReuseIdentifier: section.reuseIdentifier)
        }
    }
}

// MARK: - UITableViewDataSource
extension TableViewDataSource: UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int
    { return self.allSections().count }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        guard let section = self.section(at: section) else
        { return 0 }
        
        return section.numberOfObjects()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let section = self.allSections()[indexPath.section]
        let cell = tableView.dequeueReusableCell(withIdentifier: section.reuseIdentifier,
                                                 for: indexPath)
        
        section.cell(cell, displayObjectAt: indexPath.row)
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension TableViewDataSource: UITableViewDelegate {}

