//
//  NetworkManagerUtilities.swift
//  frameproject
//
//  Created by Quang Trinh on 25/10/2022.
//

import Foundation

final class NetworkManagerUtilities {
    class func getDownloadDestinationPath(url: URL, response: URLResponse) -> URL {
        let fileManager = FileManager.default
        let directoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        if let pathComponent = response.suggestedFilename {
            return directoryURL.appendingPathComponent(pathComponent)
        }
        else {
            return directoryURL.appendingPathComponent("imageName.jpg")
        }
    }
}

