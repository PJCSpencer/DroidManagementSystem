//
//  sMockedDMS.swift
//  DroidManagementSystem
//
//  Created by Peter Spencer on 04/11/2018.
//  Copyright © 2018 Peter Spencer. All rights reserved.
//

import Foundation


class MockedDMS
{
    // MARK: - Property(s)
    
    weak var delegate: ProbeDroidRemoteResponse?
    
    var serverSockets: ServerSockets?
    {
        didSet
        { serverSockets?.delegate = self }
    }
}

// MARK: - DroidManagementSystem
extension MockedDMS: ProbeDroidRemoteRequest
{
    func numberOfProbeDroids()
    {
        let request = ProbeDroidRequest(command: .count, parameter: NullParameter())
        guard let data = request.data() else
        { return }
        
        self.serverSockets?.write(data: data)
    }
    
    func move(_ command: ProbeDroidRequest<MoveParameters>)
    {
        if let data = command.data()
        { self.serverSockets?.write(data: data) }
    }
    
    func status(_ command: ProbeDroidRequest<StatusParameter>)
    {
        if let data = command.data()
        { self.serverSockets?.write(data: data) }
    }
}

// MARK: - ServerSocketsDelegate
extension MockedDMS: ServerSocketsDelegate
{
    func read(_ data: Data)
    {
        guard let object = JSONSerialization.object(with: data) else
        { return }
        
        let response = ProbeDroidResponse(object)
        
        guard let args = response.args else
        { return }
        
        switch response.command // NB:Not great, would prefer scaling more gracefully.
        {
        case .count:
            let count = IntParameter(with: args)?.value ?? 0
            
            DispatchQueue.main.async
            { self.delegate?.numberOfProbeDroids(count) }
            
        case .move:
            if let probeDroid = ProbeDroid(with: args)
            {
                DispatchQueue.main.async
                { self.delegate?.probeDroidMoveChange(probeDroid) }
            }
            
        case .status:
            if let probeDroid = ProbeDroid(with: args)
            {
                DispatchQueue.main.async
                { self.delegate?.probeDroidStatusChange(probeDroid) }
            }
            
        default:
            print("Unsupported command.") // TODO:Support error ...
        }
    }
}

