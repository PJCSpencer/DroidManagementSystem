//
//  sServerSockets.swift
//  DroidManagementSystem
//
//  Created by Peter Spencer on 04/11/2018.
//  Copyright © 2018 Peter Spencer. All rights reserved.
//

import Foundation


protocol ServerSocketsDelegate: class
{
    func read(_ data: Data)
}

class ServerSockets: NSObject
{
    // MARK: -
    
    weak var delegate: ServerSocketsDelegate?
    
    
    // MARK: -
    
    override init()
    {
        super.init()
        
        NotificationCenter.default.addObserver(forName: DCSNotification,
                                               object: nil,
                                               queue: nil,
                                               using: self.notification(_:))
    }
    
    deinit
    { NotificationCenter.default.removeObserver(self) }
    
    
    // MARK: -
    
    func write(data: Data)
    {
        DispatchQueue.global(qos: .background).async
        { MockedDCS.doSomething(data) }
    }
}

// MARK: - Listen for notifications from MockedDCS
extension ServerSockets
{
    @objc func notification(_ notification: Notification) -> Void
    { 
        guard let data = notification.object as? Data else
        {
            self.delegate?.read(Data())
            return
        }
        self.delegate?.read(data)
    }
}

