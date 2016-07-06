//
//  Test5.swift
//  TestFutures
//
//  Created by Chris Prince on 7/6/16.
//  Copyright © 2016 Chris Prince. All rights reserved.
//

import Foundation
import BrightFutures
import Result

enum MyError: ErrorType {
    case JustAnError
    case MapError
}

// From the website:
// map returns a new Future that contains the error from this Future if this Future failed, or the return value from the given closure that was applied to the value of this Future.

// This documentation doesn't fully explain the situation to me. Or maybe what's missing is the implication of returning a failure. In this case the .map's are bypassed and it "skips" to the .onFailure handler.

// The main gist of the map seems to be to consecutively modify the result.

class Test5 : NSObject {
    // Having problems generalizing this future to returning Int? i.e., to do error handling. Perhaps just because it wasn't constructed initially to do error handling.
    class func test1() {
        future {
            /*
            var x:Int?
            do {
                x = try Test.fibonacci(-1)
            } catch (let error) {
                
            }
            return x
            */
            // try! Test.fibonacci(-1)
            return 5
        }.map { number -> String in
            if number > 5 {
                return "large"
            }
            return "small"
        }.map { sizeString in
            return sizeString == "large"
        }.onSuccess { numberIsLarge in
            // numberIsLarge is true
        }
    }
    
    class func test2() {
        future { () -> Result<Int, MyError> in
            
            // Seems like this try catch block should be implict in the Future structure. Why not allow a throws to directly propagate "up" as a failure?
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
        .map { number -> String in
            print("First map")

            if number > 5 {
                return "large"
            }
            return "small"
        }.map { sizeString -> Bool in
            print("Second map")
            
            return sizeString == "large"
        }.onSuccess { numberIsLarge in
            // numberIsLarge is true
            print(numberIsLarge)
        }.onFailure { error in
            print("onFailure: \(error)")
        }
    }
    
    // See if I can return an error from .map's. A particular stage of processing ought to be able to fail.
    class func test3() {
        future { () -> Result<Int, MyError> in
            
            // Seems like this try catch block should be implict in the Future structure. Why not allow a throws to directly propagate "up" as a failure?
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
        .map { number -> String in
            print("First map")
            
            if number > 5 {
                return "large"
            }
            return "small"
        }
        .map { sizeString -> Bool in
            print("Second map")
            
            return sizeString == "large"
        }
        .map { Bool -> Result<Bool, MyError> in
            print("Third map")
            
            return Result(error: MyError.MapError)
        }
        .onSuccess { numberIsLarge in
            print("onSuccess: \(numberIsLarge)")
        }
        .onFailure { error in
            print("onFailure: \(error)")
        }
        .onComplete { value in
            print("onComplete: \(value)")
        }
        
        /* This *does not* operate as I would have liked. 
         Synopsis of output:
         
         First map
         Second map
         Third map
         onSuccess: .Failure(MapError)
         onComplete: .Success(.Failure(MapError))
         
         It seems that while the initial future can fail and cause the .onFailure handler to be called, each stage of .map can't fail.
        */
    }
}