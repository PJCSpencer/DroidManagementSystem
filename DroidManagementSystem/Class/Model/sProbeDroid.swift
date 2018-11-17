//
//  sProbeDroid.swift
//  DroidManagementSystem
//
//  Created by Peter Spencer on 03/11/2018.
//  Copyright © 2018 Peter Spencer. All rights reserved.
//

import Foundation


typealias RequestArgs = [String:Any]

enum ProbeDroidCommand: String, ProbeDroidRequestArgs
{
    enum Keys: String
    {
        case command
        case args
    }
    
    case unkown
    case count, move, status
    
    static let support = [count, move, status]
    
    init(_ string: String)
    {
        self = ProbeDroidCommand.support.filter({ $0.rawValue == string }).first ?? .unkown
    }
    
    func args() -> RequestArgs
    { return [Keys.command.rawValue:self.rawValue] }
}

enum ProbeDroidStatus: Int
{
    enum Keys: String
    {
        case status
    }
    
    case unkown
    case pending, acknowledged, mobile, achieved // NB:Pending represents an initiated move awaiting acknowledgment.
    case offline, online
    
    var string: String
    {
        get
        {
            guard let str = String(reflecting: self).components(separatedBy: ".").last else
            { return String(reflecting: self) }
            
            return str
        }
    }
    
    init(_ args: RequestArgs)
    {
        self = (args[Keys.status.rawValue] as? Int).map { ProbeDroidStatus(rawValue: $0)! } ?? .unkown
    }
}

enum ProbeDroidResponseError: Error
{
    case failed
}

struct ProbeDroidIndex: ProbeDroidRequestArgs
{
    enum Keys: String
    {
        case index, tag
    }
    
    let tag: Int // NB:Why did I choose to use 'tag'?
    
    init(_ tag: Int)
    { self.tag = tag }
    
    init?(_ args: RequestArgs)
    {
        guard let tag = args[Keys.index.rawValue] as? Int else
        { return nil }
        
        self.tag = tag
    }
    
    func args() -> RequestArgs
    { return [Keys.index.rawValue:self.tag] }
}

struct ProbeDroidRequest<T:ProbeDroidRequestArgs>
{
    enum Keys: String
    {
        case args
    }
    
    let command: ProbeDroidCommand
    let parameter: T
    
    func data() -> Data?
    {
        let message = self.command.args().merging([Keys.args.rawValue:self.parameter.args()]) { $1 }
        return message.data()
    }
}

struct ProbeDroidResponse
{
    let command: ProbeDroidCommand
    let args: RequestArgs?
    let error: ProbeDroidResponseError?
    
    init(_ object: RequestArgs)
    {
        if let command =  object[ProbeDroidCommand.Keys.command.rawValue] as? String,
            let args = object[ProbeDroidCommand.Keys.args.rawValue] as? RequestArgs
        {
            self.command = ProbeDroidCommand(command)
            self.args = args
            self.error = nil
        }
        else
        {
            self.command = .unkown
            self.args = nil
            self.error = .failed
        }
    }
}

struct NullParameter: ProbeDroidRequestArgs
{
    func args() -> RequestArgs
    { return [:] }
}

struct IntParameter: ProbeDroidRequestArgs
{
    enum Keys: String
    {
        case value
    }
    
    let value: Int
    
    init(value: Int)
    { self.value = value }
    
    init?(with args: RequestArgs)
    {
        guard let value = args[Keys.value.rawValue] as? Int else
        { return nil }
        
        self.value = value
    }
    
    func args() -> RequestArgs
    { return [Keys.value.rawValue:self.value] }
}

struct MoveParameters: ProbeDroidRequestArgs
{
    let index: ProbeDroidIndex
    let location: Location
    
    func args() -> RequestArgs
    { return index.args().merging(self.location.args()) { $1 } }
}

struct StatusParameter: ProbeDroidRequestArgs
{
    let index: ProbeDroidIndex
    
    func args() -> RequestArgs
    { return index.args() }
}

// MARK: - Protocol
protocol ProbeDroidRequestArgs
{
    func args() -> RequestArgs
}

protocol ProbeDroidRemoteRequest: class // NB:These should be abstracted to support dedicated stream(s) ...
{
    func numberOfProbeDroids()
    
    func move(_ command: ProbeDroidRequest<MoveParameters>)
    
    func status(_ command: ProbeDroidRequest<StatusParameter>)
}

protocol ProbeDroidRemoteResponse: class
{
    func numberOfProbeDroids(_ count: Int) // NB:Support response ..?
    
    func probeDroidMoveChange(_ probeDroid: ProbeDroid)
    
    func probeDroidStatusChange(_ probeDroid: ProbeDroid)
}

@objcMembers
class ProbeDroid: NSObject
{
    // MARK: - Property(s)
    
    private(set) var index: ProbeDroidIndex
    
    dynamic var status: Int = ProbeDroidStatus.unkown.rawValue
    {
        didSet
        {
            if status == ProbeDroidStatus.acknowledged.rawValue
            { status = ProbeDroidStatus.mobile.rawValue }
        }
    }
    
    dynamic var location: Location = Location(x: 0, y: 0)
    
    dynamic var detection: Detection = Detection(false)
    
    
    // MARK: - Initialisation
    
    init(_ tag: Int)
    { self.index = ProbeDroidIndex(tag) }
    
    init?(with args: RequestArgs)
    {
        guard let index = ProbeDroidIndex(args) else
        { return nil }
        
        self.index = index
        self.status = ProbeDroidStatus(args).rawValue
        self.location = Location(args)
        self.detection = Detection(args)
    }
}

