//
//  Test6.swift
//  TestFutures
//
//  Created by Chris Prince on 7/6/16.
//  Copyright © 2016 Chris Prince. All rights reserved.
//

import Foundation
import BrightFutures
import Result

class Test6 : NSObject {
    static let testError = false
    
    // Since .map doesn't really allow a stage of processing to fail. See if a .flatMap can do this.
    
    // Seems like I can do it, though this notation is starting to get pretty arcane. I would think this is commmon use case. Or at least it's one place where I'd like to use the notation. E.g., to make a series of consecutive async callbacks where each could fail. This could be a series of server calls or a series of UI operations.
    
    // The name "flatMap" doesn't have much intuitive appeal to me.
    
    // Seems like we have a strictly sequential flow from stage of .flatMap to .flatMap. One stage has to complete to provide the input for the next. Each stage can operate asynchronously.
    
    class func test1() {
        future { () -> Result<Int, MyError> in
            var x:Int?
            do {
                x = try Test.fibonacci(10)
            } catch (let error) {
                print(error)
                return Result(error: MyError.JustAnError)
            }
            
            print("fibonacci result: \(x)")
            
            return Result(value: x!)
        }
        .flatMap { number -> Future<String, MyError> in
            print("First flatMap")
            
            // Tricky syntax! I just made an error here. Keeping the Result's and Future's sorted out is difficult. Is there some simplified notation for this?
            return future { () -> Result<String, MyError> in
                if number > 5 {
                    return Result(value: "large")
                }
                return Result(value: "small")
            }
        }
        .flatMap { sizeString -> Future<Bool, MyError> in
            print("Second flatMap")

            return future { () -> Result<Bool, MyError> in
                return Result(value: sizeString == "large")
            }
        }
        .flatMap { isLarge -> Future<Bool, MyError> in
            print("Third flatMap")
            
            return future { () -> Result<Bool, MyError> in
                if testError {
                    return Result(error: MyError.MapError)
                }
                else {
                    return Result(value: isLarge)
                }
            }
        }
        .onSuccess { result in
            print("onSuccess: \(result)")
        }
        .onFailure { error in
            print("onFailure: \(error)")
        }
        .onComplete { value in
            print("onComplete: \(value)")
        }
    }
    
    /*
    Finally, got what I wanted. I can fail out of a particular stage of .flatMap'ing and not get .onSuccess called.
     
    First flatMap
    Second flatMap
    Third flatMap
    onFailure: MapError
    onComplete: .Failure(MapError)
    */
}