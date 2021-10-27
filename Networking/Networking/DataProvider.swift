//
//  DataProvider.swift
//  Networking
//
//  Created by Никита Иващенков on 26/10/2021.
//  Copyright © 2021 Alexey Efimov. All rights reserved.
//

import UIKit

class DataProvider: NSObject {

    private var downloadTask: URLSessionDownloadTask!
    var fileLocation: ((URL) -> ())?
    var onProgress: ((Double) -> ())?
    
    private lazy var bgSession: URLSession = {
        let config = URLSessionConfiguration.background(withIdentifier: "ru.swiftbook.Networking")
//        config.isDiscretionary = true
        config.sessionSendsLaunchEvents = true
        return URLSession(configuration: config,
                          delegate: self,
                          delegateQueue: nil)
    }()
    
    func startDownload() {
        if let url = URL(string: "https://speed.hetzner.de/100MB.bin") {
            downloadTask = bgSession.downloadTask(with: url)
            downloadTask.earliestBeginDate = Date().addingTimeInterval(3)
            downloadTask.countOfBytesClientExpectsToSend = 512
            downloadTask.countOfBytesClientExpectsToReceive = 100 * 1024 * 1024
            downloadTask.resume()
        }
    }
    
    func stopDownload() {
        downloadTask.cancel()
    }
}

extension DataProvider: URLSessionDelegate {
    // вызывается по завершении всех фоновых задач, помещенных в очередь с нашим идентификатором,
    // который мы будем должны передать в AppDelegate
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        
        DispatchQueue.main.async {
            guard
                let appDelegate = UIApplication.shared.delegate as? AppDelegate,
                let completionHandler = appDelegate.bgSessionComplitionHandler
                else { return }
            
            appDelegate.bgSessionComplitionHandler = nil
            completionHandler()
        }
    }
}

extension DataProvider: URLSessionDownloadDelegate {
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("did finish downloading: \(location.absoluteString)")
        DispatchQueue.main.async {
            self.fileLocation?(location)
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        guard totalBytesExpectedToWrite != NSURLSessionTransferSizeUnknown else { return }
        
        let progress = Double(totalBytesWritten) / Double(totalBytesExpectedToWrite)
        
        print("Download progress: \(progress)")
        
        DispatchQueue.main.async {
            self.onProgress?(progress)
        }
    }
}
