//
//  Test4.swift
//  TestFutures
//
//  Created by Chris Prince on 7/6/16.
//  Copyright © 2016 Chris Prince. All rights reserved.
//

// .andThen is a method of the Async protocol. Future abides by the Async protocol.

import Foundation
import BrightFutures
import Result

// I just noticed the notation if-case below. See https://www.natashatherobot.com/swift-2-pattern-matching-with-if-case/

class Test4 : NSObject {
    class func test1() {
        var answer = 10
        
        // I have explicitly added the Result type, for readability. e.g., to make it clear that when you call the .andThen method, you get a Result<Int, NoError> parameter passed to the callback.
        
        // It looks like each stage of the .andThen steps cannot introduce a failure. It seems like this is just a cascade of processing the same Result. Which I guess is what the website meant, but I didn't get on first read:
        
        // From website:
        // Using the andThen function on a Future, the order of callbacks can be explicitly defined. The closure passed to andThen is meant to perform side-effects and does not influence the result. andThen returns a new Future with the same result as this future
        
        // I'm not really understanding at this point when the order of callbacks would *not* be explicitly defined.
        
        _ = Future<Int, NoError>(value: 4)
            .andThen { (result:Result<Int, NoError>) in
                print("First .andThen")

                switch result {
                case .Success(let val):
                    answer *= val
                    
                // Does getting Failure here necessarily mean that you won't proceed to the next .andThen?
                case .Failure(_):
                    break
                }
            }
            .andThen { (result:Result<Int, NoError>) in
                print("Second .andThen")
                
                if case .Success(_) = result {
                    answer += 2
                }
            }
    }
}