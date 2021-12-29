//
//  FileUtils.swift
//  Palico
//
//  Created by Junhao Wang on 12/28/21.
//

import Foundation

public enum FileUtils {
    public static func getURL(path: String) -> URL {
        guard let filePathURL = URL(string: path) else {
            fatalError("Invalid filepath: \(path)")
        }
        
        let directory = filePathURL.deletingLastPathComponent().path
        let filename = filePathURL.deletingPathExtension().lastPathComponent
        let filenameExtension = filePathURL.pathExtension
        
        guard let shaderURL = Bundle.module.url(forResource: filename,
                                                withExtension: filenameExtension,
                                                subdirectory: directory) else {
            fatalError("Invalid filepath: \(path)")
        }
        
        return shaderURL
    }
}
