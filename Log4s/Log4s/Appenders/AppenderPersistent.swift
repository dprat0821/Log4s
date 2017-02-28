//
//  AppenderPersistent.swift
//  Log4s
//
//  Created by Liqing Pan on 2017-02-27.
//  Copyright © 2017 GeekMouse. All rights reserved.
//

import Foundation

let defaultPath = FileManager.default.urls(for: FileManager.SearchPathDirectory.cachesDirectory, in: FileManager.SearchPathDomainMask.userDomainMask)[0].appendingPathComponent("Logs")
let defaultSizePerFile = 10   //In unit of KB
let defaultTotalSize = 10000 //In unit of KB

public class AppenderPersistent: Appender{
    public var path:URL
    public var fileSize: Int
    public var filesTotalSize: Int = defaultTotalSize
    public var format : DateFormatter
    
    private var numFilesEstimate: Int = 0
    
    var buffer: String = ""
    
    override public func dump(_ event: Event, completion: @escaping (Error?)-> Void){
        buffer += event.message + "\n"
        if buffer.characters.count >= fileSize * 1000 {
            let fileName = format.string(from: event.timestamp)
            saveLog(name: fileName, body: buffer){(error) in
                if let error = error {
                    completion(error)
                }
                else{
                    self.deleteOldLogs()
                    self.buffer = ""
                    completion(nil)
                }
                
            }
        }
        completion(nil)
    }
    
    private func deleteOldLogs(){
        //
        // TODO: Delete old log files if the total size is larger than filesTotalSize
        //
    }
    
    private func saveLog(name:String,body: String, completion: @escaping (Error?)-> Void){
        let url = defaultPath.appendingPathComponent(name).appendingPathExtension("log")
        do{
            try buffer.write(to: url, atomically: true, encoding: String.Encoding.utf8)
            deleteOldLogs()
        }catch{
            completion(error)
        }
    }
    
    public init(locatedAt path:URL = defaultPath, fileSize: Int = defaultSizePerFile) {
        self.path = path
        self.fileSize = fileSize
        format = DateFormatter()
        format.dateFormat = "yy/MM/dd HH:mm:ss"
    }
    
    deinit {
        print("deinit")
        let fileName = format.string(from: Date())
        saveLog(name: fileName, body: buffer){(error) in
            
        }
    }
    
}
