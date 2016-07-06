//
//  Test3.swift
//  TestFutures
//
//  Created by Chris Prince on 7/6/16.
//  Copyright © 2016 Chris Prince. All rights reserved.
//

import Foundation
import BrightFutures
import Result

/*
enum NoError: ErrorType {
    case NoSuchError
}
*/

class Test3 : NSObject {
    // From the website:
    // Now let's assume the role of an API author who wants to use BrightFutures. The 'producer' of a future is called a Promise. A promise contains a future that you can immediately hand to the client. The promise is kept around while performing the asynchronous operation, until calling Promise.success(result) or Promise.failure(error) when the operation ended. Futures can only be completed through a Promise.
    
    // CGP: Where are the Promise's in the examples in Test and Test2? They are "completed" right?
    
    // CGP: In what sense does asyncCalculation keep the promise around? I guess that since the .async block has a reference to promise, and implicitly that will be a strong reference, we'll keep the promise around while performing the async operation.
    
    // The example as given didn't define "NoError", but some assumptions are being made about it:
    
    // From the website: 
    // NoError indicates that the Future cannot fail. This is guaranteed by the type system, since NoError has no initializers.
    
    // Ahh. Now I see. To use NoError, you have to import Result. That wasn't obvious to me. Why doesn't the BrightFutures Cocoapod import Result so I don't have to?
    
    // I believe this is actually my first async example. Since it queues up the promise operation asynchronously.
    
    class func asyncCalculation() -> Future<String, NoError> {
        let promise = Promise<String, NoError>()
        
        Queue.global.async {
            // do a complicated task and then hand the result to the promise:
            promise.success("forty-two")
        }
        
        return promise.future
    }
    
    // It would be good to have, on the website, recommended indentation notation for using the asyncCalculation method.
    class func test1() {
        asyncCalculation()
        .onSuccess { resultString in
            print(resultString)
        }
    }
}