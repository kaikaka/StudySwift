//
//  Logger.swift
//  StudySwift
//
//  Created by Yoon on 2021/3/7.
//

import Foundation

let log = Logger.shared

final class Logger {
    static let shared = Logger()
    private init() { }

    static let logDateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        return f
    }()
}

extension Logger {
    func error<T>(
        _ message: T,
        file: StaticString = #file,
        function: StaticString = #function,
        line: UInt = #line
    ) {
        Log(message, type: .error, file: file, function: function, line: line)
    }

    func warning<T>(
        _ message: T,
        file: StaticString = #file,
        function: StaticString = #function,
        line: UInt = #line
    ) {
        Log(message, type: .warning, file: file, function: function, line: line)
    }

    func info<T>(
        _ message: T,
        file: StaticString = #file,
        function: StaticString = #function,
        line: UInt = #line
    ) {
        Log(message, type: .info, file: file, function: function, line: line)
    }

    func debug<T>(
        _ message: T,
        file: StaticString = #file,
        function: StaticString = #function,
        line: UInt = #line
    ) {
        Log(message, type: .debug, file: file, function: function, line: line)
    }
}

enum LogType: String {
    case error = "❤️ ERROR"
    case warning = "💛 WARNING"
    case info = "💙 INFO"
    case debug = "💚 DEBUG"
}

// MARK: - 自定义打印方法

func Log<T>(
    _ message: T,
    type: LogType,
    file: StaticString = #file,
    function: StaticString = #function,
    line: UInt = #line
) {
    #if DEBUG
        let time = Logger.logDateFormatter.string(from: Date())
        let fileName = (file.description as NSString).lastPathComponent
        print("\(time) \(type.rawValue) \(fileName):(\(line))\n------------------------------------------------\n\(message)\n------------------------------------------------")
    #endif
}

