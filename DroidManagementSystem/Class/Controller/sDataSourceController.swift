//
//  sDataSourceController.swift
//  DroidManagementSystem
//
//  Created by Peter Spencer on 04/11/2018.
//  Copyright © 2018 Peter Spencer. All rights reserved.
//

import UIKit


class DataSourceController: UIViewController
{
    // MARK: - Property(s)
    
    var speechController: SpeechController = SpeechController()
    
    var dataSource: ProbeDroidDataSource?
    {
        didSet
        {
            guard let tableView = self.view as? UITableView else
            { return }
            
            dataSource?.register(tableView)
            tableView.reloadData()
        }
    }
    
    
    // MARK: - Managing the View
    
    override func loadView()
    {
        let tableView = UITableView(frame: UIScreen.main.bounds, style: .plain)
        tableView.rowHeight = 64
        tableView.isScrollEnabled = false
        
        self.view = tableView
        
        self.speechController.view.alpha = 0.7
        self.view.addSubview(self.speechController.view)
    }
    
    
    // MARK: - Responding to View Events
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
        let section = ProbeDroidDataSourceSection()
        self.dataSource = ProbeDroidDataSource(with: [section])
        
        self.dataSource?.refreshDelegate = self
        self.dataSource?.dms = MockedDMS()
        self.dataSource?.dms?.numberOfProbeDroids()
    }
}

// MARK: - RefreshDelegate
extension DataSourceController: DataSourceRefresh
{
    func dataSource(_ dataSource: DataSource, insert indexPaths: [IndexPath])
    {
        guard let tableView = self.view as? UITableView else
        { return }
        tableView.insertRows(at: indexPaths, with: .automatic)
    }
    
    func dataSource(_ dataSource: DataSource, reload indexPaths: [IndexPath])
    { 
        guard let tableView = self.view as? UITableView else
        { return }
        tableView.reloadRows(at: indexPaths, with: .left)
    }
}

