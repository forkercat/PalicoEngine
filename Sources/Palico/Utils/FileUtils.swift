//
//  FileUtils.swift
//  Palico
//
//  Created by Junhao Wang on 12/28/21.
//

import Foundation

public enum FileUtils {
    public static func getURL(path: String) -> URL? {
        guard let filePathURL = URL(string: path) else {
            assertionFailure("Invalid filepath: \(path)")
            return nil
        }
        
        let directory = filePathURL.deletingLastPathComponent().path
        let filename = filePathURL.deletingPathExtension().lastPathComponent
        let filenameExtension = filePathURL.pathExtension
        
        guard let shaderURL = Bundle.module.url(forResource: filename,
                                                withExtension: filenameExtension,
                                                subdirectory: directory) else {
            assertionFailure("Invalid filepath: \(path)")
            return nil
        }
        
        return shaderURL
    }
}
