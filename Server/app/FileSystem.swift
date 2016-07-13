//
//  FileSystem.swift
//  Server
//
//  Created by Chris Prince on 7/8/16.
//  Copyright © 2016 Crossroad Labs. All rights reserved.
//

import Foundation
import BrightFutures
import Result
import Express

enum FileSystemError: ErrorType {
    case FailedToReadURL
}

protocol FileSystemDataResult {
    static func createDataResult(result: NSData) -> Action<AnyContent>
}

class FileSystem {
    // Read the entire file as an NSData object.
    /*
    class func read(fileURL:NSURL) -> Future<NSData, FileSystemError> {
        let promise = Promise<NSData, FileSystemError>()
        
        Queue.global.async {
            if let fileData = NSData(contentsOfURL:fileURL) {
                promise.success(fileData)
            }
            else {
                promise.failure(.FailedToReadURL)
            }
        }
        
        return promise.future
    }
    */
    
    // Run into problems with type conversions when I try use this in main.swift. E.g., Cannot convert value of type 'Future<ServerAction, AnyError>' to type 'Future<Action<AnyContent>, AnyError>' in coercion
    /*
    class func read2<FutureResult:FileSystemDataResult>(fileURL:NSURL) -> Future<FutureResult, AnyError> {
        let promise = Promise<FutureResult, AnyError>()
        
        Queue.global.async {
            if let fileData = NSData(contentsOfURL:fileURL) {
                promise.success(FutureResult(result: fileData))
            }
            else {
                promise.failure(AnyError(cause: FileSystemError.FailedToReadURL))
            }
        }
        
        return promise.future
    }
    */
    
    // This syntax seems really dependent on the specific's of the server. But I can't figure out a way to adapt the Future types. Errors, when they occur, are returned in the AnyContent. i.e., AnyError should really be NoError (but, due to type conversion issues, I can't seem to do this).
    class func read(filePath:String, convert:(NSData?) -> Action<AnyContent>) -> Future<Action<AnyContent>, AnyError> {
        let promise = Promise<Action<AnyContent>, AnyError>()
        
        Queue.global.async {
            let fileData = NSData(contentsOfFile:filePath)
            let action = convert(fileData)
            promise.success(action)
        }
        
        return promise.future
    }
}