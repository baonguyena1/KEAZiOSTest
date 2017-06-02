//
//  Logger.swift
//  KEAZiOSTest
//
//  Created by Bao Nguyen on 6/2/17.
//  Copyright © 2017 Bao Nguyen. All rights reserved.
//

import UIKit

// Define prefix of Log
enum LogEvent: String {
    case e = "[ERROR]" // error
    case i = "[INFO]" // info
    case d = "[DEBUG]" // debug
    case v = "[VERBOSE]" // verbose
    case w = "[WARNING]" // warning
    case s = "[SErVER]" // server
}

final class Logger {
    static var dateFormat = "yyyy-MM-dd hh:mm:ssSSS"
    
    static var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.locale = Locale.current
        formatter.timeZone = TimeZone.current
        return formatter
    }
    
    // Get file name
    private class func sourceFileName(filePath: String) -> String {
        let components = filePath.components(separatedBy: "/")
        return components.isEmpty ? "" : components.last!
    }
    
    static func log(message: String, event: LogEvent,fileName: String = #file, line: Int = #line,column: Int = #column,
        funcName: String = #function) {
    #if DEBUG
        print("\(Date().toString()) \(event.rawValue)[\(sourceFileName(filePath:fileName))]:\(line) \(column) \(funcName) -> \(message)")
    #endif
    }
}

extension Date {
    func toString() -> String {
        return Logger.dateFormatter.string(from: self as Date)
    }
}
