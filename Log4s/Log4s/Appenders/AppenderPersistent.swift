//
//  AppenderPersistent.swift
//  Log4s
//
//  Created by Liqing Pan on 2017-02-27.
//  Copyright © 2017 GeekMouse. All rights reserved.
//

import Foundation

let defaultPath = FileManager.default.urls(for: .cachesDirectory, in: FileManager.SearchPathDomainMask.userDomainMask)[0].appendingPathComponent("Logs")
let defaultSizePerFile: Double = 0.01   //In unit of KB
let defaultTotalSize: Double = 10000 //In unit of KB

public class AppenderPersistent: Appender{
    public var path:URL
    public var fileSize: Double
    public var filesTotalSize: Double = defaultTotalSize
    public var format : DateFormatter
    
    private var numFilesEstimate: Int = 0
    
    var buffer: String = ""
    

    
    override public func dump(_ event: Event, completion: @escaping (Error?)-> Void){
        buffer += event.message + "\n"
        let sizeBuffer = buffer.characters.count
        if  Double(sizeBuffer) >= fileSize * 1000.0 {
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
        if !FileManager.default.fileExists(atPath: url.absoluteString){
            if let data = Data(base64Encoded: buffer, options: .ignoreUnknownCharacters){
                //
                // FIXIT: Failed to write.
                //
                FileManager.default.createFile(atPath: url.absoluteString, contents: data, attributes: nil)
            }
            deleteOldLogs()
            
        }
    }
    
    public init(locatedAt path:URL = defaultPath, fileSize: Double = defaultSizePerFile) {
        self.path = path
        var isDir: ObjCBool = false
        var isDirExist = false
        if FileManager.default.fileExists(atPath: path.absoluteString, isDirectory: &isDir){
            isDirExist = isDir.boolValue
        }
        else{
            isDirExist = false
        }
        
        if !isDirExist{
            do{
               try FileManager.default.createDirectory(at: self.path, withIntermediateDirectories: true, attributes: nil)
            }catch{
                //
                // TODO: Handle the case failed to create directory
                //
                print(error.localizedDescription)
            }
            
        }
        
        
        self.fileSize = fileSize
        format = DateFormatter()
        format.dateFormat = "yyyyMMdd HH:mm:ss"
    }
    
    deinit {
        //
        // FIXIT: deinit is not called when the app is terminating. Some logs might be lost
        //
//        print("deinit")
        let fileName = format.string(from: Date())
        saveLog(name: fileName, body: buffer){(error) in
            
        }
    }
    
}
