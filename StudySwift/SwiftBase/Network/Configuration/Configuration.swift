//
//  Configuration.swift
//  StudySwift
//
//  Created by Yoon on 2021/3/11.
//

import Moya

public extension Network {
    
    class Configuration {
        public static var `default`: Configuration = Configuration()
        
        public var addingHeaders: (TargetType) -> [String: String] = { _ in [:] }
        
        public var replacingTask: (TargetType) -> Task = { $0.task }
        
        public var timeoutInterval: TimeInterval = 60
        
        public var plugins: [PluginType] = []
        
        public var manager:Session?
        
        public init() {}
    }
}
