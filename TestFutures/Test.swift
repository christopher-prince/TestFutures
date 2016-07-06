//
//  Test.swift
//  TestFutures
//
//  Created by Chris Prince on 7/6/16.
//  Copyright © 2016 Chris Prince. All rights reserved.
//

import Foundation
import BrightFutures

enum Errors : ErrorType {
    case GeneralError
}

// Need NSObject based superclass for this to be available to Objective-C (i.e., in TestFutures-Swift.h).
class Test : NSObject {
    class func fibonacci(n:Int) throws -> Int {
        if n <= 0 {
            throw Errors.GeneralError
        }
        
        print("fibonacci(\(n))")
        
        switch n {
        case 1, 2:
            return 1
        default:
            return try! fibonacci(n-1) + fibonacci(n-2)
        }
    }
    
    /* What does the notation

    future {
        try! fibonacci(50)
    }.
     
    mean? i.e., putting a dot after a "}"
     
    */
    class func test1() {
        future {
            // Question: Shouldn't there be a return here? Does Swift have implict returns with the last statement in a closure? YES! But seemingly just for closures that have a single statement! Perhaps also functions in general with a single statement?
            try! fibonacci(10)
        }.onSuccess { num in
            print(num)
        }
    }
    
    class func returnString() -> String {
        return "Hello World!"
    }
    
    // Working on understanding "}." notation.
    class func test2() {
        let result = future {
            try! fibonacci(50)
        }
        
        result.onSuccess { num in
            print(num)
        }
    }
    
    class func test3() {
        let result = future() {
            try! fibonacci(50)
        }
        
        result.onSuccess { num in
            print(num)
        }
    }
    
    // So, future is a function that returns a Future. So, "}." is a shorthand for executing a function on the return result of calling future (a Future)
}