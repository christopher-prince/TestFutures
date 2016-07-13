//
//  main.swift
//

import Express
import TidyJSON
import BrightFutures
import Result

let app = express()

// CGP: What is a view? I guess this sets outgoing headers?
app.views.register(JsonView())

// Figuring out how to deal with futures, valid return values, and error handling.
app.post("/test") { request -> Future<Action<AnyContent>, AnyError> in
    //check if JSON has arrived
    guard let json = request.body?.asJSON(),
        let jsonDict = json.object,
        let filePath = jsonDict["filePath"],
        let filePathString = filePath.string else {
            return future { () -> Result<Action<AnyContent>, AnyError> in
                var response = [
                    "status": "error"
                ]
                return Result(value: Action.render(JsonView.name, context: response))
            }
    }

    var response = [
        "status": "ok"
    ]
    
    return future { () -> Result<Action<AnyContent>, AnyError> in
        Result(value: Action.render(JsonView.name, context: response))
    }
}

// Same test, but without the "() -> Result<Action<AnyContent>, AnyError> in" syntax in the returned Futures.
app.post("/test2") { request -> Future<Action<AnyContent>, AnyError> in
    //check if JSON has arrived
    guard let json = request.body?.asJSON(),
        let jsonDict = json.object,
        let filePath = jsonDict["filePath"],
        let filePathString = filePath.string else {
            return future {
                var response = [
                    "status": "error"
                ]
                return Result(value: Action.render(JsonView.name, context: response))
            }
    }
    
    var response = [
        "status": "ok"
    ]
    
    return future {
        Result(value: Action.render(JsonView.name, context: response))
    }
}

// Parameters: JSON object {"filePath" : "<filePath>"}
app.post("/readFile") { request -> Future<Action<AnyContent>, AnyError> in
    //check if JSON has arrived
    guard let json = request.body?.asJSON(),
        let jsonDict = json.object,
        let filePath = jsonDict["filePath"],
        let filePathString = filePath.string else {
        return future {
            var response = [
                "status": "error",
                "message" : "Invalid request"
            ]
            return Result(value: Action.render(JsonView.name, context: response))
        }
    }

    print("json: \(json)")
    print("json: \(json.object)")
        
    return FileSystem.read(filePathString, convert: { data -> Action<AnyContent> in
        // The type of `response` must be [String:String], or you get odd results-- {} only is returned from server. See http://stackoverflow.com/questions/38340795/in-swift-express-using-bright-futures-how-to-handle-asynchronous-operations/38340973#38340973
        var response = [String:String]()
        
        var status:String
        
        if data == nil {
            status = "error"
            response["message"] = "Couldn't read file"
        }
        else {
            status = "ok"
            response["result"] = data!.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
        }

        response["status"] = status

        return Action.render(JsonView.name, context: response)
    }).onSuccess { action in
        print("action: \(action)")
    }
}

// This works!
app.post("/Simpler") { request -> Future<Action<AnyContent>, AnyError> in
    
    let promise = Promise<Action<AnyContent>, AnyError>()
    
    Queue.global.async {
        var response = [
            "status": "It worked!"
        ]
        promise.success(Action.render(JsonView.name, context: response))
    }
    
    return promise.future
}

app.post("/SimplerRead") { request -> Future<Action<AnyContent>, AnyError> in
    
    let promise = Promise<Action<AnyContent>, AnyError>()
    
    Queue.global.async {
        var response = [String:String]()
        var status:String
        
        status = "error"
        response["message"] = "Could not read file"
        
        response["status"] = status
        
        promise.success(Action.render(JsonView.name, context: response))
    }
    
    return promise.future
}

app.all("/*") { request in
    return Action.ok("Got a unknown request.")
}

app.listen(9999).onSuccess { server in
    print("Express was successfully launched on port", server.port)
}

// Apparently Bundles are not used. This gives nil
/*
let bundle = NSBundle(forClass: app.dynamicType)
let url = bundle.URLForResource("Example", withExtension: "txt")
print("url: \(url)")
 */

// This works: Path starts from root of Server directory
/*
let fileData = NSData(contentsOfFile: "./Example.txt")
print("fileData: \(fileData)")
*/

app.run()