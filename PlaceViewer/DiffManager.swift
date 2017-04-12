//
//  DiffManager.swift
//  PlaceViewer
//
//  Created by Cory Wilhite on 4/11/17.
//  Copyright © 2017 Cory Wilhite. All rights reserved.
//

import UIKit
import Zip

struct Diff {
    let timestamp: UInt32
    let x: UInt32
    let y: UInt32
    let colorId: UInt32
}

// function is separate from the Diff struct as to not effect the memory layout 
func getColor(for diff: Diff) -> UIColor {
    return colorLookup[Int(diff.colorId)]
}

let colorLookup: [UIColor] = [
    UIColor(hexString: "ffffff"),
    UIColor(hexString: "e4e4e4"),
    UIColor(hexString: "888888"),
    UIColor(hexString: "222222"),
    UIColor(hexString: "ffa7d1"),
    UIColor(hexString: "e50000"),
    UIColor(hexString: "e59500"),
    UIColor(hexString: "a06a42"),
    UIColor(hexString: "e5d900"),
    UIColor(hexString: "94e044"),
    UIColor(hexString: "02be01"),
    UIColor(hexString: "00d3dd"),
    UIColor(hexString: "0083c7"),
    UIColor(hexString: "0000ea"),
    UIColor(hexString: "cf6ee4"),
    UIColor(hexString: "820080")
]


class DiffManager {
    static let shared = DiffManager()
    private init() { }
    
    var diffs: [Diff] = DiffManager.getDiffs()
    
    static func getDiffs() -> [Diff] {
        
        // using force unwraps here because we don't want to try to recover from file errors here. all files and data is expected to be in the right place
        
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let path = documentsDirectory.appendingPathComponent("diffs.bin")
        
        // if the diffs.bin file has already been unzipped, we'll get data here
        var data: Data! = try? Data(contentsOf: path)
        
        // if not then unzip the file from the bundle into the documentsDirectory
        if data == nil {
        
            let filePath = Bundle.main.url(forResource: "diffs", withExtension: "bin.zip")!
        
            try! Zip.unzipFile(filePath, destination: documentsDirectory, overwrite: true, password: nil) { (progress) in
                print("unzip progress: \(progress)")
            }
            
            data = try! Data(contentsOf: path)
        }
        
        let diffs = data.withUnsafeMutableBytes { (diffPtrStart: UnsafeMutablePointer<Diff>) -> [Diff] in
            let diffSize = MemoryLayout<Diff>.size
            let diffsCount = (data.endIndex - data.startIndex) / diffSize
            let buffer = UnsafeMutableBufferPointer(start: diffPtrStart, count: diffsCount)
            return Array(buffer)
        }
        
        return diffs
            
    }
}


