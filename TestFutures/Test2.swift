//
//  Test2.swift
//  TestFutures
//
//  Created by Chris Prince on 7/6/16.
//  Copyright © 2016 Chris Prince. All rights reserved.
//

import Foundation
import BrightFutures
import Result

enum ReadmeError: ErrorType {
    case RequestFailed, TimeServiceError
}

class Test2 : NSObject {
    static let forceTestingOfError = true
    
    // The web page example didn't fully illustrate the intended purpose of the example. That of error handling. I added .onFailure to it.
    
    class func test1() {
        future { () -> Result<NSDate, ReadmeError> in
            let now: NSDate? = self.getDateFromServer()
            if let now = now {
                return Result(value: now)
            }
            
            return Result(error: ReadmeError.TimeServiceError)
        }
        .onSuccess { dateValue in
            // value will be the NSDate from the server
            print(dateValue)
        }
        .onFailure { error in
            print(error)
        }
    }
    
    // This is just a stub for now. No server access is taking place, and thus this is really just synchronous.
    class func getDateFromServer() -> NSDate? {
        if forceTestingOfError {
            return nil
        }
        else {
            return NSDate()
        }
    }
}



