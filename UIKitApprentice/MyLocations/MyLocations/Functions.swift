//
//  Functions.swift
//  MyLocations
//
//  Created by Sergei Sai on 03.02.2022.
//

import Foundation

func afterDelay(_ seconds: Double, run: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: run)
}

let applicationsDocumentDirectory: URL = {
    return FileManager.default.urls(for: .documentDirectory,
                                   in: .userDomainMask).first!
}()

let dataSaveFailedNotification = Notification.Name(rawValue: "DataSaveFailedNotification")

func fatalCoreDataError(_ error: Error) {
    print("*** Fatal error: \(error)")
    NotificationCenter.default.post(name: dataSaveFailedNotification, object: nil)
}
